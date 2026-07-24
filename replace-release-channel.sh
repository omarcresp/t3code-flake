#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -ne 3 ]]; then
  echo "Usage: $0 TARGET SOURCE CHANNEL" >&2
  exit 1
fi

target="$1"
source="$2"
channel="$3"
header="  ${channel} = {"
footer="  };"

if [[ ! -f "${target}" || ! -f "${source}" ]]; then
  echo "Both TARGET and SOURCE must exist." >&2
  exit 1
fi

if [[ "$(grep -Fxc "${header}" "${target}")" -ne 1 ]]; then
  echo "Expected exactly one '${channel}' block in ${target}." >&2
  exit 1
fi

if [[ "$(grep -Fxc "${header}" "${source}")" -ne 1 ]]; then
  echo "Expected exactly one '${channel}' block in ${source}." >&2
  exit 1
fi

temporary="$(mktemp "${target}.XXXXXX")"
trap 'rm -f "${temporary}"' EXIT

awk -v header="${header}" -v footer="${footer}" '
  FNR == NR {
    if ($0 == header) {
      capturing = 1
    }

    if (capturing) {
      replacement = replacement $0 ORS
    }

    if (capturing && $0 == footer) {
      capturing = 0
    }

    next
  }

  $0 == header {
    printf "%s", replacement
    skipping = 1
    next
  }

  skipping {
    if ($0 == footer) {
      skipping = 0
    }
    next
  }

  {
    print
  }
' "${source}" "${target}" >"${temporary}"

chmod 0644 "${temporary}"
mv "${temporary}" "${target}"
trap - EXIT
