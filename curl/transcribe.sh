#!/usr/bin/env bash
# Speech to text (async): create a task, poll until it completes, print the text.
#
# Model: nemotron-3.5-transcribe — transcribes an audio file, or the audio track of
# a video. The result is TEXT, not a media file:
#   data.resultJson   a JSON *string*: {"task","text","duration","transcript_url",...}
#   transcript_url    the full result as a JSON file (also in data.resultUrls[0]),
#                     kept 30 days. With "timestamps": true it also holds words[]
#                     (word, start, end, speaker) and diarization[].
#
# Input: audio_url must be a public URL our servers can download directly — mp3,
# wav, m4a, aac, flac, ogg, opus, webm, or an mp4 / mov with an audio track. Up to
# 60 minutes and 200 MB per file. Whole-file transcription; no realtime streaming.
#
# Options:
#   "timestamps": true        word-level times + speaker labels (up to 8 speakers)
#   "target_language": "en"   translate the speech instead (32 codes; only translation
#                             to or from English is guaranteed)
#   The two cannot be combined — the API answers 400.
#
# COST: $0.0025 per audio minute ($0.15 per hour), billed by the second. Timestamps,
#       speaker labels and translation cost nothing extra. A 1-minute clip is
#       $0.0025 — well inside the $0.10 trial credit. Failed tasks are not charged.
#
# Needs jq: resultJson is a JSON string inside the JSON reply, and has to be parsed
# a second time (`fromjson`).
#
# Usage: APIMODELS_API_KEY=sk-... AUDIO_URL=https://your-host/your-audio.mp3 ./transcribe.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"
: "${AUDIO_URL:?Set AUDIO_URL to a public link to your own audio or video file}"
command -v jq >/dev/null || { echo "this example needs jq (https://jqlang.org)"; exit 1; }

BASE_URL="https://api.apimodels.app/v1"

# 1) Create the task
TASK_ID=$(curl -sS -X POST "${BASE_URL}/audio/generations" \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg url "$AUDIO_URL" '{
    model: "nemotron-3.5-transcribe",
    audio_url: $url,
    timestamps: true
  }')" | jq -r '.data.taskId // empty')

[ -n "$TASK_ID" ] || { echo "create failed"; exit 1; }
echo "task: ${TASK_ID}"

# 2) Poll until completed / failed
while true; do
  RESP=$(curl -sS "${BASE_URL}/audio/generations?task_id=${TASK_ID}" \
    -H "Authorization: Bearer ${APIMODELS_API_KEY}")
  STATE=$(printf "%s\n" "$RESP" | jq -r '.data.state')
  echo "state: ${STATE}"
  case "$STATE" in
    completed) break ;;
    failed)    echo "FAILED: $RESP"; exit 1 ;;
    *)         sleep 3 ;;
  esac
done

# 3) resultJson is a JSON string — parse it once more
RESULT=$(printf "%s\n" "$RESP" | jq '.data.resultJson | fromjson')
echo "duration: $(printf "%s\n" "$RESULT" | jq -r '.duration') s"
echo "text:"
printf "%s\n" "$RESULT" | jq -r '.text'

# 4) Optional: the full result file. words[] / diarization[] exist only with timestamps: true.
TRANSCRIPT_URL=$(printf "%s\n" "$RESULT" | jq -r '.transcript_url')
echo "transcript_url: ${TRANSCRIPT_URL}"
echo "first words:"
curl -sS "$TRANSCRIPT_URL" \
  | jq -r '(.words // [])[:5][] | "  \(.start)s – \(.end)s  \(.speaker // "-")  \(.word)"'
