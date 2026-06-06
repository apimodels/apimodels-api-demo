"""Video generation (async): create a task, then poll until it completes.

Example: Grok Imagine Video 1.5 (Beta) — image-to-video, flat per-clip pricing.

    export APIMODELS_API_KEY="sk-..."
    python video_generation.py
"""
import os
import time
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
BASE_URL = "https://apimodels.app/api/v1"
HEADERS = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}

# 1) Create the task
create = requests.post(
    f"{BASE_URL}/video/generations",
    headers=HEADERS,
    json={
        "model": "grok-imagine-video-1.5-beta",
        "image_urls": ["https://your-domain.com/path/reference.png"],
        "prompt": "the character slowly turns to camera and smiles",
        "resolution": "720p",
        "duration": 5,  # 5 / 8 / 10 / 12 / 15
    },
    timeout=60,
)
create.raise_for_status()
task_id = create.json()["data"]["taskId"]
print("task:", task_id)

# 2) Poll until completed / failed
while True:
    status = requests.get(
        f"{BASE_URL}/video/generations",
        headers=HEADERS,
        params={"task_id": task_id},
        timeout=60,
    ).json()
    state = status["data"]["state"]
    print("state:", state)
    if state == "completed":
        print("Video URL:", status["data"]["resultUrls"][0])
        break
    if state == "failed":
        raise SystemExit(f"Generation failed: {status['data'].get('failMsg')}")
    time.sleep(10)
