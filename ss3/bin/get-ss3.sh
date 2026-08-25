#!/usr/bin/env bash
# Fetch the pinned Stock Synthesis executable for this assessment.
#
# The SS3 binary determines the model results, so it is pinned here by
# release tag and verified by SHA-256. The binary itself is not committed
# (platform-specific); run this script to fetch it into ss3/bin/.
#
# Usage:  bash ss3/bin/get-ss3.sh

set -euo pipefail

SS3_VERSION="v3.30.22.1"
REPO="nmfs-ost/ss3-source-code"
BASE="https://github.com/${REPO}/releases/download/${SS3_VERSION}"
DEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${DEST_DIR}/ss3_opt"

case "$(uname -s)/$(uname -m)" in
  Darwin/arm64)  ASSET="ss3_opt_osx_arm64"
                 SHA="38870aa03998f415e087759778fb5ac3be926920c66c644e1c1078f756ea5dc5" ;;
  Darwin/x86_64) ASSET="ss3_opt_osx"
                 SHA="564b3998382d1a46c8bab6c1aed9356bbe7be06e6e976bc601f35f2a9b758ddb" ;;
  Linux/x86_64)  ASSET="ss3_opt_linux"
                 SHA="e840c87091420108f5302b65a3ad79369eca57da38e5add51d6604a8890b0469" ;;
  *) echo "Unsupported platform: $(uname -s)/$(uname -m)" >&2
     echo "Windows users: download ss3_opt_win.exe from ${BASE}" >&2
     echo "  expected sha256 a50737e4d0ac2af46d8258c9880bd7b2a9ee105ff6777f06a279199678caca97" >&2
     exit 1 ;;
esac

echo "Fetching ${ASSET} (${SS3_VERSION}) ..."
curl -fL --retry 3 -o "${DEST}" "${BASE}/${ASSET}"

if command -v shasum >/dev/null 2>&1; then
  GOT="$(shasum -a 256 "${DEST}" | awk '{print $1}')"
else
  GOT="$(sha256sum "${DEST}" | awk '{print $1}')"
fi

if [ "${GOT}" != "${SHA}" ]; then
  echo "CHECKSUM MISMATCH for ${ASSET}" >&2
  echo "  expected ${SHA}" >&2
  echo "  got      ${GOT}" >&2
  rm -f "${DEST}"
  exit 1
fi

chmod +x "${DEST}"
xattr -d com.apple.quarantine "${DEST}" 2>/dev/null || true
echo "OK: ${DEST}"
echo "    ${SS3_VERSION}  sha256 ${SHA}"
