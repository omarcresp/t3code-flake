#!/usr/bin/env bash
set -euo pipefail

repo="pingdotgg/t3code"
api_base="https://api.github.com/repos/${repo}"

for cmd in curl jq; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Missing required command: ${cmd}" >&2
    exit 1
  fi
done

to_sri() {
  local digest="$1"
  local hex_hash="${digest#sha256:}"

  if command -v nix >/dev/null 2>&1; then
    nix hash convert --hash-algo sha256 --from base16 --to sri "${hex_hash}"
  elif command -v xxd >/dev/null 2>&1 && command -v base64 >/dev/null 2>&1; then
    printf 'sha256-%s\n' "$(printf '%s' "${hex_hash}" | xxd -r -p | base64 | tr -d '\n')"
  else
    echo "Missing required command for SRI conversion. Install nix or xxd+base64." >&2
    exit 1
  fi
}

# Upstream names each platform's asset differently per channel. Candidates are
# listed in preference order; readiness and hashing both use the first match.
asset_defs='
  def valid_digest:
    type == "string"
    and test("^sha256:[0-9a-fA-F]{64}$");

  def version:
    .tag_name | ltrimstr("v");

  def candidate_names($channel; $system):
    version as $version
    | if $system == "x86_64-linux" then
        [
          (if $channel == "stable" then "T3-Code-x86_64.AppImage" else "T3-Code-Nightly-x86_64.AppImage" end),
          # Releases before upstream PR #36306 (stable 0.1.9 and older) put the
          # version in the AppImage name. Drop this once stable is past 0.1.9.
          "T3-Code-\($version)-x86_64.AppImage"
        ]
      else
        ["T3-Code-\($version)-arm64.zip"]
      end;

  def ready_asset($channel; $system):
    . as $release
    | first(
        candidate_names($channel; $system)[] as $name
        | $release.assets[]?
        | select(.name == $name and (.digest | valid_digest))
      );

  def ready($channel):
    [ready_asset($channel; "x86_64-linux"), ready_asset($channel; "aarch64-darwin")]
    | length == 2;
'

select_ready_release() {
  local releases_json="$1"
  local channel="$2"
  local candidate_tag release_json selected_tag

  candidate_tag="$(
    jq -r --arg channel "${channel}" '
      [
        .[]
        | select(
            if $channel == "stable" then
              .prerelease == false
            else
              .prerelease == true
              and (.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+-" + $channel + "\\.[0-9]{8}\\.[0-9]+$"))
            end
          )
      ][0].tag_name // empty
    ' <<<"${releases_json}"
  )"

  release_json="$(
    jq -c --arg channel "${channel}" "${asset_defs}"'
      [
        .[]
        | select(
            if $channel == "stable" then
              .prerelease == false
            else
              .prerelease == true
              and (.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+-" + $channel + "\\.[0-9]{8}\\.[0-9]+$"))
            end
          )
        | select(ready($channel))
      ][0] // empty
    ' <<<"${releases_json}"
  )"

  if [[ -z "${release_json}" ]]; then
    echo "Could not find a complete ${channel} release in the first 100 GitHub releases." >&2
    exit 1
  fi

  selected_tag="$(jq -r '.tag_name' <<<"${release_json}")"
  if [[ -n "${candidate_tag}" && "${candidate_tag}" != "${selected_tag}" ]]; then
    echo "Newest ${channel} release '${candidate_tag}' is not ready; keeping '${selected_tag}' until all required assets and digests are published." >&2
  fi

  printf '%s\n' "${release_json}"
}

write_release_notes() {
  local channel="$1"
  local release_json="$2"

  if [[ -z "${RELEASE_NOTES_DIR:-}" ]]; then
    return
  fi

  mkdir -p "${RELEASE_NOTES_DIR}"
  jq -r '.body // ""' <<<"${release_json}" >"${RELEASE_NOTES_DIR}/${channel}.md"
  jq -r '.html_url // ""' <<<"${release_json}" >"${RELEASE_NOTES_DIR}/${channel}.url"
}

emit_source() {
  local release_json="$1"
  local channel="$2"
  local system="$3"
  local asset_json

  asset_json="$(
    jq -c --arg channel "${channel}" --arg system "${system}" "${asset_defs}"'
      ready_asset($channel; $system) // empty
    ' <<<"${release_json}"
  )"
  if [[ -z "${asset_json}" ]]; then
    echo "Could not find a ${channel} asset for system '${system}'." >&2
    jq -r '.assets[].name' <<<"${release_json}" >&2
    exit 1
  fi

  printf '      %s = {\n' "${system}"
  printf '        file = "%s";\n' "$(jq -r '.name' <<<"${asset_json}")"
  printf '        hash = "%s";\n' "$(to_sri "$(jq -r '.digest' <<<"${asset_json}")")"
  printf '      };\n'
}

emit_channel() {
  local channel="$1"
  local release_json="$2"
  local tag version system

  tag="$(jq -r '.tag_name' <<<"${release_json}")"
  if [[ -z "${tag}" || "${tag}" == "null" ]]; then
    echo "Could not read ${channel} tag_name from GitHub release payload." >&2
    exit 1
  fi

  version="${tag#v}"

  printf '  %s = {\n' "${channel}"
  printf '    version = "%s";\n' "${version}"
  printf '    sources = {\n'
  for system in x86_64-linux aarch64-darwin; do
    emit_source "${release_json}" "${channel}" "${system}"
  done
  printf '    };\n'
  printf '  };\n'
}

curl_auth_args=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  curl_auth_args=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

releases_json="$(curl -fsSL "${curl_auth_args[@]}" -H "Accept: application/vnd.github+json" "${api_base}/releases?per_page=100")"
stable_release="$(select_ready_release "${releases_json}" stable)"
nightly_release="$(select_ready_release "${releases_json}" nightly)"

write_release_notes stable "${stable_release}"
write_release_notes nightly "${nightly_release}"

printf '{\n'
emit_channel stable "${stable_release}"
printf '\n'
emit_channel nightly "${nightly_release}"
printf '}\n'
