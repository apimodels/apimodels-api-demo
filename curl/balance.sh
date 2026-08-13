#!/usr/bin/env bash
# Account balance — query the available credit balance (USD) for your API key.
# Read-only; never charges credits.
# Usage: APIMODELS_API_KEY=sk-... ./balance.sh
set -euo pipefail
: "${APIMODELS_API_KEY:?Set APIMODELS_API_KEY}"

curl -sS https://api.apimodels.app/v1/balance \
  -H "Authorization: Bearer ${APIMODELS_API_KEY}"
# -> { "code":200, "data": { "balance":12.5, "total":12.5, "frozen":0, "currency":"USD" } }
