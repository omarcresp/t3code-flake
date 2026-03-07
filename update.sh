#!/usr/bin/env bash
set -euo pipefail

repo="pingdotgg/t3code"
api_url="https://api.github.com/repos/${repo}/releases/latest"

for cmd in curl jq nix; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Missing required command: ${cmd}" >&2
    exit 1
  fi
done

release_json="$(curl -fsSL "${api_url}")"
tag="$(jq -r '.tag_name' <<<"${release_json}")"
if [[ -z "${tag}" || "${tag}" == "null" ]]; then
  echo "Could not read tag_name from GitHub release payload." >&2
  exit 1
fi

version="${tag#v}"
asset_name="T3-Code-${version}-x86_64.AppImage"

asset_json="$(
  jq -cr --arg name "${asset_name}" '.assets[] | select(.name == $name)' <<<"${release_json}" \
    | head -n 1
)"
if [[ -z "${asset_json}" ]]; then
  echo "Could not find AppImage asset '${asset_name}' in release '${tag}'." >&2
  jq -r '.assets[].name' <<<"${release_json}" >&2
  exit 1
fi

digest="$(jq -r '.digest' <<<"${asset_json}")"
url="$(jq -r '.browser_download_url' <<<"${asset_json}")"

if [[ -z "${digest}" || "${digest}" == "null" || -z "${url}" || "${url}" == "null" ]]; then
  echo "Asset is missing digest and/or browser_download_url fields." >&2
  exit 1
fi

if [[ ! "${digest}" =~ ^sha256:[0-9a-fA-F]{64}$ ]]; then
  echo "Unexpected digest format: ${digest}" >&2
  exit 1
fi

hex_hash="${digest#sha256:}"
sri_hash="$(nix hash convert --hash-algo sha256 --from base16 --to sri "${hex_hash}")"

cat <<EOF
# Update values for flake.nix
version = "${version}";
url = "${url}";
hash = "${sri_hash}";
EOF
