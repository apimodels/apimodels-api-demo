#!/usr/bin/env bash
# Voice cloning (Minimax): upload a sample -> clone into your own voice_id -> use in TTS.
#
# ⚠️  COST: cloning a voice is $15.80, charged once, the moment the clone succeeds.
#     That is the upstream custom-voice fee passed through at cost — it is NOT a
#     per-second or per-character charge, and it is far more than the $0.10 signup
#     credit, so a new account will get 402 "Insufficient credits" here. Do not run
#     this script to "try the API out"; run text-to-speech.sh instead (~$0.004) and
#     come back when you actually want a permanent custom voice.
#     Synthesis with the cloned voice afterwards is billed at the normal TTS rate.
#
# Usage: APIMODELS_API_KEY=sk-... ./voice-clone.sh path/to/sample.mp3
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"
SAMPLE="${1:?Pass a clean voice sample, e.g. ./voice-clone.sh sample.mp3}"
BASE="https://api.apimodels.app/v1"
AUTH="Authorization: Bearer ${APIMODELS_API_KEY}"
VOICE_ID="myBrandVoice01"   # must start with a letter, >= 8 chars

# 1) Upload the sample
FILE_ID=$(curl -sS -X POST "${BASE}/minimax/files" -H "${AUTH}" \
  -F "purpose=voice_clone" -F "file=@${SAMPLE}" \
  | sed -n 's/.*"file_id":[ ]*\([0-9]*\).*/\1/p')
echo "file_id: ${FILE_ID}"

# 2) Clone -> your voice_id
curl -sS -X POST "${BASE}/minimax/voice/clone" -H "${AUTH}" -H "Content-Type: application/json" \
  -d "{ \"file_id\": ${FILE_ID}, \"voice_id\": \"${VOICE_ID}\" }"
echo

# 3) Speak with the cloned voice
curl -sS -X POST "${BASE}/minimax/tts" -H "${AUTH}" -H "Content-Type: application/json" \
  -d "{ \"model\": \"minimax-speech-02-turbo\", \"text\": \"This is my cloned voice.\", \"voice_setting\": { \"voice_id\": \"${VOICE_ID}\" } }"
echo
