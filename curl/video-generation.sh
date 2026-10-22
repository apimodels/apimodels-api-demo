#!/usr/bin/env bash
# Video generation (async): create a task, then poll until it completes.
#
# Model: veo-3.1-fast-fhd — VEO 3.1 Fast, 1080p, native audio, flat price per clip.
#
# COST: $0.07 per clip (flat — duration and resolution are fixed by the channel).
#       This is the cheapest video model we run, and it is the only one a brand-new
#       account can afford: signup credit is $0.10. Every other video model costs
#       more than the whole signup credit (grok-video-3 is $0.12 for its 6s minimum,
#       seedance-2.0-fast starts around $0.36), so those will 402 "Insufficient
#       credits" until you top up.
#
# Result URLs are kept for 7 days — download the file if you want to keep it.
#
# Usage: APIMODELS_API_KEY=sk-... ./video-generation.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"

# 1) Create the task.
#    Text-to-video: a prompt is all you need, no assets to host anywhere.
#    For image-to-video add:  "images": ["https://<publicly reachable>.png"]
#    (it must be a public URL — our servers fetch it, so localhost won't work).
TASK_ID=$(curl -sS -X POST https://api.apimodels.app/v1/video/generations \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "veo-3.1-fast-fhd",
    "prompt": "a red panda barista pulls an espresso shot, steam rising, warm morning light through the cafe window",
    "aspect_ratio": "16:9"
  }' | sed -n 's/.*"taskId":"\([^"]*\)".*/\1/p')

echo "task: ${TASK_ID}"

# 2) Poll until completed / failed
while true; do
  RESP=$(curl -sS "https://api.apimodels.app/v1/video/generations?task_id=${TASK_ID}" \
    -H "Authorization: Bearer ${APIMODELS_API_KEY}")
  STATE=$(echo "$RESP" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p')
  echo "state: ${STATE}"
  case "$STATE" in
    completed) echo "$RESP"; break ;;
    failed)    echo "FAILED: $RESP"; exit 1 ;;
    *)         sleep 10 ;;
  esac
done
