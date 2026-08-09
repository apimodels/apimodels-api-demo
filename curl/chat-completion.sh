#!/usr/bin/env bash
# Chat / LLM — OpenAI-compatible. Works with any OpenAI client by changing base_url.
#
# COST: token-based. A one-sentence answer from claude-sonnet-4-6 costs well under
#       $0.001, so this runs many times over inside the $0.10 signup credit.
#
# Usage: APIMODELS_API_KEY=sk-... ./chat-completion.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"

curl -sS -X POST https://apimodels.app/api/v1/chat/completions \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-6",
    "messages": [
      { "role": "user", "content": "Explain what an API gateway is in one sentence." }
    ]
  }'
# See https://apimodels.app/docs for the full list of LLM model names, or call
# GET https://apimodels.app/api/v1/models (no key needed) for the live list.
