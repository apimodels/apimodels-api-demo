#!/usr/bin/env bash
# Image edit — pass a reference image and the model edits it instead of starting blank.
#
# The field is `image_url` (one image) or `image_urls` (several, for combining).
# Both must be PUBLICLY reachable https URLs: our servers fetch them, so localhost,
# private IPs and files behind a login will not work.
#
# ⚠️  This example will NOT run as-is — swap the placeholder below for a real image
#     of yours first. There is no public sample image to point at, so leaving one
#     here would only break later. Everything else in this repo runs unedited.
#
# COST: $0.008 at 1024x1024 / $0.015 at 1536x1024 (gpt-image-2-lite; the price
#       follows the output megapixels, 1K / 2K / 4K → $0.008 / $0.015 / $0.025).
#
# Result URLs are kept for 7 days — download the file if you want to keep it.
#
# Usage: APIMODELS_API_KEY=sk-... ./image-edit.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"

curl -sS -X POST https://api.apimodels.app/v1/images/generations \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-2-lite",
    "prompt": "Change the season to winter with falling snow",
    "image_url": "https://your-domain.com/path/photo.png",
    "size": "1536x1024",
    "response_format": "url"
  }'
# -> { "created": 1780000000, "data": [ { "url": "https://..." } ] }
