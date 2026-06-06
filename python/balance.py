"""Account balance — query your available credit balance (USD).

Read-only; never charges credits.

    export APIMODELS_API_KEY="sk-..."
    python balance.py
"""
import os
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
BASE_URL = "https://apimodels.app/api/v1"

resp = requests.get(
    f"{BASE_URL}/balance",
    headers={"Authorization": f"Bearer {API_KEY}"},
    timeout=30,
)
resp.raise_for_status()
data = resp.json()["data"]
print(f"Available: {data['balance']} {data['currency']}")
print(f"Total: {data['total']}  Frozen: {data['frozen']}")
