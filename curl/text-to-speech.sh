#!/usr/bin/env bash
# Text-to-speech — streams audio bytes; write them straight to a file.
# Usage: APIMODELS_API_KEY=sk-... ./text-to-speech.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"

curl -sS -X POST https://apimodels.app/api/v1/tts/stream \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "eleven-tts-flash",
    "text": "Hello from API Models. This audio was generated through one unified API."
  }' \
  --output speech.mp3

echo "saved -> speech.mp3"
