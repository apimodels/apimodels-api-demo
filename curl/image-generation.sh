#!/usr/bin/env bash
# Image generation (synchronous) — returns the image URL(s) directly.
# Usage: APIMODELS_API_KEY=sk-... ./image-generation.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY (create one at https://apimodels.app/en/console/api-keys)}"

curl -sS -X POST https://apimodels.app/api/v1/images/generations-sync \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-2-lite",
    "prompt": "A red panda barista pulling an espresso shot, studio lighting, ultra detailed",
    "size": "1024x1024"
  }'
# -> { "code": 200, "data": { "state": "completed", "resultUrls": ["https://..."] } }
