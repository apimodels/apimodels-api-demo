"""Image generation — synchronous, OpenAI-compatible.

POST /images/generations with a WxH ``size`` and no ``callback_url`` makes the call
synchronous: it waits for the image and returns the OpenAI shape
``{"created": ..., "data": [{"url": "https://..."}]}``.
Drop ``size`` (or add ``callback_url``) and the same endpoint becomes async instead,
returning ``{"code": 200, "data": {"taskId": ..., "state": "pending"}}`` which you
poll with ``GET /images/generations?task_id=<id>``.

COST: $0.008 at 1024x1024 (gpt-image-2-lite, 1K tier). 2K is $0.015, 4K $0.025.
      Comfortably inside the $0.10 signup credit.

Result URLs are kept for 7 days — download the file if you want to keep it.

Create your key at https://apimodels.app/console/api-keys then:
    export APIMODELS_API_KEY="sk-..."
    python image_generation.py
"""
import os
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
BASE_URL = "https://api.apimodels.app/v1"

resp = requests.post(
    f"{BASE_URL}/images/generations",
    headers={"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"},
    json={
        "model": "gpt-image-2-lite",
        "prompt": "A red panda barista pulling an espresso shot, studio lighting",
        "size": "1024x1024",
        "response_format": "url",  # omit to also get b64_json inline
    },
    timeout=300,
)
resp.raise_for_status()
data = resp.json()
print("Image URL:", data["data"][0]["url"])
