#!/usr/bin/env bash
# Build a TestFlight-ready IPA. Requires Apple Distribution cert + Xcode account.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! security find-identity -v -p codesigning | grep -q 'Apple Distribution'; then
  cat <<'EOF'
Missing Apple Distribution signing certificate.

Fix (one time):
  1. Open Xcode → Settings → Accounts → add your Apple ID (team LJU4593RX3).
  2. Select the team → Manage Certificates… → + → Apple Distribution.

Then re-run this script.

If an archive already exists, you can export from Xcode Organizer instead:
  open build/ios/archive/Runner.xcarchive
EOF
  if [[ -d build/ios/archive/Runner.xcarchive ]]; then
    open build/ios/archive/Runner.xcarchive
  fi
  exit 1
fi

flutter build ipa \
  --export-options-plist=ios/ExportOptions.plist \
  "$@"
