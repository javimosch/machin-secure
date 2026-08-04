#!/bin/sh
# build machin-secure — single static binary + rules.json
set -e
cd "$(dirname "$0")"
machin encode src/secure.src > secure.mfl
machin build secure.mfl -o secure
echo "built: $(ls -la secure | awk '{print $5, $9}')"
./secure --help | head -3
