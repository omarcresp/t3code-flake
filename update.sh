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

fetch_stable_release() {
  local release_json
  release_json="$(curl -fsSL "${api_base}/releases/latest")"

  local tag prerelease
  tag="$(jq -r '.tag_name' <<<"${release_json}")"
  prerelease="$(jq -r '.prerelease' <<<"${release_json}")"

  if [[ -z "${tag}" || "${tag}" == "null" ]]; then
    echo "Could not read stable tag_name from GitHub release payload." >&2
    exit 1
  fi

  if [[ "${prerelease}" != "false" ]]; then
    echo "GitHub latest release '${tag}' is marked prerelease; refusing to use it as stable." >&2
    exit 1
  fi

  printf '%s\n' "${release_json}"
}

fetch_nightly_release() {
  local releases_json
  releases_json="$(curl -fsSL "${api_base}/releases?per_page=100")"

  local release_json
  release_json="$(
    jq -c '
      [
        .[]
        | select(.prerelease == true)
        | select(.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+-nightly\\.[0-9]{8}\\.[0-9]+$"))
      ][0] // empty
    ' <<<"${releases_json}"
  )"

  if [[ -z "${release_json}" ]]; then
    echo "Could not find a prerelease with a nightly tag in the first 100 GitHub releases." >&2
    exit 1
  fi

  printf '%s\n' "${release_json}"
}

asset_hash() {
  local release_json="$1"
  local channel="$2"
  local system="$3"
  local version="$4"
  local suffix="$5"
  local asset_name="T3-Code-${version}-${suffix}"

  local asset_json
  asset_json="$(
    jq -cr --arg name "${asset_name}" '.assets[] | select(.name == $name)' <<<"${release_json}" \
      | head -n 1
  )"
  if [[ -z "${asset_json}" ]]; then
    echo "Could not find ${channel} asset '${asset_name}' for system '${system}'." >&2
    jq -r '.assets[].name' <<<"${release_json}" >&2
    exit 1
  fi

  local digest
  digest="$(jq -r '.digest' <<<"${asset_json}")"

  if [[ -z "${digest}" || "${digest}" == "null" ]]; then
    echo "Asset '${asset_name}' is missing the digest field." >&2
    exit 1
  fi

  if [[ ! "${digest}" =~ ^sha256:[0-9a-fA-F]{64}$ ]]; then
    echo "Unexpected digest format for '${asset_name}': ${digest}" >&2
    exit 1
  fi

  to_sri "${digest}"
}

emit_channel() {
  local channel="$1"
  local release_json="$2"
  local tag version x86_hash arm_hash

  tag="$(jq -r '.tag_name' <<<"${release_json}")"
  if [[ -z "${tag}" || "${tag}" == "null" ]]; then
    echo "Could not read ${channel} tag_name from GitHub release payload." >&2
    exit 1
  fi

  version="${tag#v}"
  x86_hash="$(asset_hash "${release_json}" "${channel}" "x86_64-linux" "${version}" "x86_64.AppImage")"
  arm_hash="$(asset_hash "${release_json}" "${channel}" "aarch64-darwin" "${version}" "arm64.zip")"

  printf '  %s = {\n' "${channel}"
  printf '    version = "%s";\n' "${version}"
  printf '    sources = {\n'
  printf '      x86_64-linux.hash = "%s";\n' "${x86_hash}"
  printf '      aarch64-darwin.hash = "%s";\n' "${arm_hash}"
  printf '    };\n'
  printf '  };\n'
}

stable_release="$(fetch_stable_release)"
nightly_release="$(fetch_nightly_release)"

printf '{\n'
emit_channel stable "${stable_release}"
printf '\n'
emit_channel nightly "${nightly_release}"
printf '}\n'
