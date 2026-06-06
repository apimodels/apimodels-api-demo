#!/usr/bin/env bash
# Image edit — pass one or more input image URLs in "image" to edit/combine them.
# Usage: APIMODELS_API_KEY=sk-... ./image-edit.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"

curl -sS -X POST https://apimodels.app/api/v1/images/generations-sync \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-2-lite",
    "prompt": "Change the season to winter with falling snow",
    "image": ["https://your-domain.com/path/photo.png"],
    "size": "1536x1024"
  }'
