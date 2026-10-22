#!/usr/bin/env bash
# Text-to-speech — streams audio bytes; write them straight to a file.
#
# ElevenLabs TTS lives on POST /tts/stream (NOT /audio/generations — that endpoint
# does not accept eleven-tts-* ids). Valid models: eleven-tts-flash, eleven-tts-turbo,
# eleven-tts-multilingual, eleven-tts-v3.
#
# COST: $0.0425 per 1000 characters on flash/turbo ($0.085 on multilingual/v3), with
#       a minimum charge of one tenth of that. The line below bills about $0.004 —
#       well inside the $0.10 signup credit.
#
# Usage: APIMODELS_API_KEY=sk-... ./text-to-speech.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"

curl -sS -X POST https://api.apimodels.app/v1/tts/stream \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "eleven-tts-flash",
    "text": "Hello from API Models. This audio was generated through one unified API."
  }' \
  --output speech.mp3

echo "saved -> speech.mp3"
