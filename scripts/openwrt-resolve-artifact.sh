#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Использование: $0 <release> <target> <subtarget> <sdk|imagebuilder>" >&2
  exit 64
fi

release="$1"
target="$2"
subtarget="$3"
kind="$4"

base_url="https://downloads.openwrt.org/releases/${release}/targets/${target}/${subtarget}"
sha_url="${base_url}/sha256sums"

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

case "$kind" in
  sdk)
    artifact_pattern='openwrt-sdk-.*Linux-x86_64\.tar\.(zst|xz|gz)$'
    ;;
  imagebuilder)
    artifact_pattern='openwrt-imagebuilder-.*Linux-x86_64\.tar\.(zst|xz|gz)$'
    ;;
  *)
    echo "Неизвестный тип артефакта: ${kind}. Ожидается sdk или imagebuilder." >&2
    exit 64
    ;;
esac

artifact_name="$({
  fetch_text "$sha_url" |
    grep -E "$artifact_pattern" |
    awk '{print $2}' |
    sed 's#^\*##' |
    head -n1
} || true)"

if [[ -z "$artifact_name" ]]; then
  echo "Не удалось найти ${kind} в ${sha_url}" >&2
  exit 1
fi

printf '%s\n' "${base_url}/${artifact_name}"
