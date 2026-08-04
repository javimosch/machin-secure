#!/bin/sh
# machin-secure GitHub Action entrypoint.
# Runs a scan and writes a SARIF 2.1.0 file for github/codeql-action/upload-sarif.
# Exit 1 only on a real tool error (bad target/rules); exit 0 on clean OR on
# findings (exit code 2 from `secure` means high/critical findings exist — the
# SARIF was still written, so let the upload + code-scanning severity settings
# decide whether the run "fails", not the scan step).
set -e

TARGET="${INPUT_TARGET:-.}"
RULES="${INPUT_RULES:-/usr/local/share/machin-secure/rules.json}"
OUTPUT="${INPUT_OUTPUT:-machin-secure.sarif}"

cd "$GITHUB_WORKSPACE"

# `secure` exits 2 on high/critical findings — expected, not an error here.
# Disable set -e for this one command so we can capture and reinterpret it.
set +e
/usr/local/bin/secure --sarif --target "$TARGET" --rules "$RULES" > "$OUTPUT"
code=$?
set -e

if [ "$code" = "1" ]; then
  echo "::error::machin-secure failed (exit 1) — see SARIF output or run secure directly"
  cat "$OUTPUT"
  exit 1
fi

if [ "$code" = "2" ]; then
  echo "::warning::machin-secure found high/critical findings — SARIF written to $OUTPUT"
else
  echo "::notice::machin-secure scan complete — SARIF written to $OUTPUT"
fi
