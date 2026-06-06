"""Image generation (synchronous) via the API Models REST API.

Create your key at https://apimodels.app/en/console/api-keys then:
    export APIMODELS_API_KEY="sk-..."
    python image_generation.py
"""
import os
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
BASE_URL = "https://apimodels.app/api/v1"

resp = requests.post(
    f"{BASE_URL}/images/generations-sync",
    headers={"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"},
    json={
        "model": "gpt-image-2-lite",
        "prompt": "A red panda barista pulling an espresso shot, studio lighting",
        "size": "1024x1024",
    },
    timeout=180,
)
resp.raise_for_status()
data = resp.json()
print("Image URL:", data["data"]["resultUrls"][0])
