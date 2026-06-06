#!/usr/bin/env bash
# Video generation (async): create a task, then poll until it completes.
# Example uses Grok Imagine Video 1.5 (Beta) — image-to-video, flat per-clip price.
# Usage: APIMODELS_API_KEY=sk-... ./video-generation.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"

# 1) Create the task
TASK_ID=$(curl -sS -X POST https://apimodels.app/api/v1/video/generations \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "grok-imagine-video-1.5-beta",
    "image_urls": ["https://your-domain.com/path/reference.png"],
    "prompt": "the character slowly turns to camera and smiles",
    "resolution": "720p",
    "duration": 5
  }' | sed -n 's/.*"taskId":"\([^"]*\)".*/\1/p')

echo "task: ${TASK_ID}"

# 2) Poll until completed / failed
while true; do
  RESP=$(curl -sS "https://apimodels.app/api/v1/video/generations?task_id=${TASK_ID}" \
    -H "Authorization: Bearer ${APIMODELS_API_KEY}")
  STATE=$(echo "$RESP" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p')
  echo "state: ${STATE}"
  case "$STATE" in
    completed) echo "$RESP"; break ;;
    failed)    echo "FAILED: $RESP"; exit 1 ;;
    *)         sleep 10 ;;
  esac
done
