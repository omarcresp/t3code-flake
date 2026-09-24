"""Exercise updater selection without network access: python3 -m unittest discover -s tests."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


def release(version, rev="a" * 40, complete=True):
    return {
        "tag_name": "v" + version,
        "target_commitish": rev,
        "prerelease": "-" in version,
        "body": "Preview notes",
        "html_url": "https://example.com/" + version,
        "assets": [
            {"name": f"T3-Code-{version}-{suffix}", "digest": "sha256:" + "ab" * 32}
            for suffix in (["x86_64.AppImage", "arm64.zip"] if complete else ["arm64.zip"])
        ],
    }


class UpdateTest(unittest.TestCase):
    def run_update(self, previews, associations, fail_api=False):
        with tempfile.TemporaryDirectory() as directory:
            work = Path(directory)
            (work / "releases.json").write_text(json.dumps(previews + [
                release("1.0.0"), release("1.0.1-nightly.20260923.1")
            ]))
            (work / "pulls.json").write_text(json.dumps(associations))
            curl = work / "curl"
            curl.write_text('''#!/usr/bin/env python3
import json, os, pathlib, sys
from urllib.parse import urlparse, parse_qs
root = pathlib.Path(os.environ["FIXTURES"])
url = urlparse(sys.argv[-1])
if "/commits/" in url.path:
    if os.environ.get("FAIL_API") == "1":
        sys.exit(22)
    rev = url.path.split("/commits/")[1].split("/")[0]
    pulls = json.loads((root / "pulls.json").read_text()).get(rev, [])
    page = int(parse_qs(url.query)["page"][0])
    print(json.dumps(pulls[(page-1)*100:page*100]))
else:
    print((root / "releases.json").read_text())
''')
            curl.chmod(0o755)
            result = subprocess.run(["bash", str(ROOT / "update.sh")], env={
                **os.environ, "PATH": str(work) + os.pathsep + os.environ["PATH"],
                "FIXTURES": str(work), "RELEASE_NOTES_DIR": str(work / "notes"),
                "FAIL_API": "1" if fail_api else "0",
            }, text=True, capture_output=True)
            notes = work / "notes" / "orchestrator.md"
            return result, notes.read_text() if notes.exists() else None

    def test_skips_unrelated_and_incomplete_previews(self):
        result, notes = self.run_update([
            release("1.0.1-preview.20260923.4", "b" * 40),
            release("1.0.1-preview.20260923.3", complete=False),
            release("1.0.1-preview.20260923.2"),
        ], {"a" * 40: [{"number": 2829}], "b" * 40: [{"number": 9999}]})
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('version = "1.0.1-preview.20260923.2";', result.stdout)
        self.assertNotIn('preview.20260923.4', result.stdout)
        self.assertNotIn('preview.20260923.3', result.stdout)
        self.assertEqual(notes, "Preview notes\n")

    def test_missing_digest_is_not_ready(self):
        preview = release("1.0.1-preview.20260923.2")
        preview["assets"][0]["digest"] = None
        result, notes = self.run_update([preview], {"a" * 40: [{"number": 2829}]})
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn(preview["tag_name"][1:], result.stdout)
        self.assertIsNone(notes)

    def test_no_matching_preview_preserves_pin(self):
        result, _ = self.run_update([release("1.0.1-preview.20260923.2")], {})
        self.assertEqual(result.returncode, 0, result.stderr)
        existing = (ROOT / "releases.nix").read_text().split("  orchestrator = {", 1)[1]
        self.assertTrue(result.stdout.endswith("  orchestrator = {" + existing))

    def test_associations_are_paginated(self):
        result, _ = self.run_update([release("1.0.1-preview.20260923.2")], {
            "a" * 40: [{"number": i} for i in range(100)] + [{"number": 2829}]
        })
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('version = "1.0.1-preview.20260923.2";', result.stdout)

    def test_api_failure_aborts_without_emitting_metadata(self):
        result, _ = self.run_update([release("1.0.1-preview.20260923.2")], {}, True)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
