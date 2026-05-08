#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Использование: $0 <release> <target> <subtarget> <board_name>" >&2
  exit 64
fi

release="$1"
target="$2"
subtarget="$3"
board_name="$4"

fetch_text() {
  local url="$1"

  if command -v curl >/dev/null 2>&1; then
    if curl -4fsSL --retry 3 --retry-delay 2 "$url"; then
      return 0
    fi
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -4 -qO- "$url"
    return 0
  fi

  echo "Не найден ни curl, ни wget для загрузки ${url}" >&2
  return 1
}

target_index_url="https://downloads.openwrt.org/releases/${release}/targets/${target}/${subtarget}/"
candidate_profile="${board_name//,/_}"
needle="openwrt-${release}-${target}-${subtarget}-${candidate_profile}-squashfs-sysupgrade.bin"

if fetch_text "$target_index_url" | grep -Fq "$needle"; then
  printf '%s\n' "$candidate_profile"
  exit 0
fi

echo "Не удалось подтвердить PROFILE по board_name=${board_name} через ${target_index_url}" >&2
exit 1
