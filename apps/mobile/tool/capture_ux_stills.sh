#!/usr/bin/env bash
# Capture UX-6 stills from the iPhone 17 Pro simulator into docs/images/mobile/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
MOBILE="$ROOT/apps/mobile"
OUT="$ROOT/docs/images/mobile"
DEVICE="${CAPTURE_DEVICE:-iPhone 17 Pro}"
LOG="$(mktemp -t compass-stills)"

cleanup() {
  rm -f "$LOG"
}
trap cleanup EXIT

mkdir -p "$OUT"

# Prefer a booted matching device; boot if needed.
if ! xcrun simctl list devices booted | grep -q "$DEVICE"; then
  xcrun simctl boot "$DEVICE" 2>/dev/null || true
fi

UDID="$(xcrun simctl list devices available \
  | sed -n "s/.*$DEVICE (\([A-F0-9-]*\)).*/\1/p" \
  | head -1)"
if [[ -z "$UDID" ]]; then
  echo "Could not resolve UDID for $DEVICE" >&2
  exit 1
fi

xcrun simctl status_bar "$UDID" override \
  --time "9:41" \
  --batteryState charged \
  --batteryLevel 100 \
  --cellularMode active \
  --cellularBars 4 \
  --dataNetwork wifi \
  --wifiMode active \
  --wifiBars 3

echo "Capturing stills on $DEVICE ($UDID) → $OUT"
echo "Log: $LOG"

cd "$MOBILE"
flutter test integration_test/capture_ux_stills_test.dart -d "$UDID" \
  >"$LOG" 2>&1 &
FPID=$!

declare -a captured=()
already() {
  local n="$1"
  for c in "${captured[@]+"${captured[@]}"}"; do
    [[ "$c" == "$n" ]] && return 0
  done
  return 1
}

while kill -0 "$FPID" 2>/dev/null; do
  while IFS= read -r marker; do
    name="${marker#<<<STILL:}"
    name="${name%>>>}"
    if already "$name"; then
      continue
    fi
    # Let the frame present after the marker.
    sleep 0.6
    dest="$OUT/${name}.png"
    xcrun simctl io "$UDID" screenshot "$dest"
    captured+=("$name")
    echo "Wrote $dest ($(wc -c <"$dest" | tr -d ' ') bytes)"
  done < <(grep -oE '<<<STILL:[A-Za-z0-9_-]+>>>' "$LOG" 2>/dev/null || true)
  sleep 0.25
done

# Final sweep in case markers arrived as the process exited.
while IFS= read -r marker; do
  name="${marker#<<<STILL:}"
  name="${name%>>>}"
  if already "$name"; then
    continue
  fi
  dest="$OUT/${name}.png"
  xcrun simctl io "$UDID" screenshot "$dest"
  captured+=("$name")
  echo "Wrote $dest ($(wc -c <"$dest" | tr -d ' ') bytes)"
done < <(grep -oE '<<<STILL:[A-Za-z0-9_-]+>>>' "$LOG" 2>/dev/null || true)

wait "$FPID"
status=$?

expected=(
  01-empty-home
  02-home-graph
  03-search-path
  04-place
  05-container
  06-asset-where
)

missing=0
for name in "${expected[@]}"; do
  if [[ ! -f "$OUT/${name}.png" ]]; then
    echo "Missing still: $name" >&2
    missing=1
  fi
done

if [[ $status -ne 0 ]]; then
  echo "flutter test failed (exit $status). Tail of log:" >&2
  tail -n 40 "$LOG" >&2
  exit "$status"
fi

if [[ $missing -ne 0 ]]; then
  echo "Capture incomplete. Log tail:" >&2
  tail -n 40 "$LOG" >&2
  exit 1
fi

# Drop obsolete foundation stills / webps from the gallery.
rm -f \
  "$OUT/01-home-dashboard.png" \
  "$OUT/01-home-dashboard.webp" \
  "$OUT/02-settings-appearance.png" \
  "$OUT/02-settings-appearance.webp" \
  "$OUT/03-about.png" \
  "$OUT/03-about.webp"

echo "All UX-6 stills captured."
