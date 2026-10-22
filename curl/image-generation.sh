#!/usr/bin/env bash
# Image generation — synchronous, OpenAI-compatible.
#
# POST /images/generations with a WxH `size` and no `callback_url` makes the call
# synchronous: it waits for the image and returns the OpenAI shape
#   { "created": 1234567890, "data": [ { "url": "https://..." } ] }
# Drop `size` (or add `callback_url`) and the same endpoint becomes async instead,
# returning { "code": 200, "data": { "taskId": "...", "state": "pending" } } which
# you then poll with GET /images/generations?task_id=<id>.
#
# COST: $0.008 at 1024x1024 (gpt-image-2-lite, 1K tier). 2K is $0.015, 4K $0.025.
#       Comfortably inside the $0.10 signup credit.
#
# Result URLs are kept for 7 days — download the file if you want to keep it.
#
# Usage: APIMODELS_API_KEY=sk-... ./image-generation.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY (create one at https://apimodels.app/console/api-keys)}"

curl -sS -X POST https://api.apimodels.app/v1/images/generations \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-2-lite",
    "prompt": "A red panda barista pulling an espresso shot, studio lighting, ultra detailed",
    "size": "1024x1024",
    "response_format": "url"
  }'
# -> { "created": 1780000000, "data": [ { "url": "https://..." } ] }
# Omit "response_format" and you also get "b64_json" inline with the URL.
