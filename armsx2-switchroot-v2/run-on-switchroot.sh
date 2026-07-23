#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 ./ARMSX2-switchroot-tegra-x1-arm64.AppImage [ARMSX2 arguments...]"
  exit 2
fi

APP="$(realpath "$1")"
shift
chmod +x "$APP"

echo "Architecture : $(uname -m)"
echo "Page size    : $(getconf PAGESIZE)"
echo "glibc        : $(ldd --version | head -n1)"
echo "CPU model    : $(grep -m1 -E 'model name|CPU part|Hardware' /proc/cpuinfo || true)"
echo

# Avoid depending on FUSE mounting and prefer Switchroot's normal X11 session.
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-xcb}"

exec "$APP" "$@"
