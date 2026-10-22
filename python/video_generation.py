"""Video generation (async): create a task, then poll until it completes.

Model: veo-3.1-fast-fhd — VEO 3.1 Fast, 1080p, native audio, flat price per clip.

COST: $0.088 per clip (flat — 8 seconds at 1080p, fixed by the channel; the 720p
      veo-3.1-fast-hd is $0.08). It fits inside the $0.10 trial credit, so on
      trial credit run this before the other paid examples. Many other video
      models cost more than the whole trial credit (grok-video-3 is $0.24 for its
      6s minimum, seedance-2.0-fast $0.28 for 4s at 480p), so those will 402
      "Insufficient credits" until you top up.

Result files are kept for 30 days, then deleted — download the file if you want
to keep it.

    export APIMODELS_API_KEY="sk-..."
    python video_generation.py
"""
import os
import time
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
BASE_URL = "https://api.apimodels.app/v1"
HEADERS = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}

# 1) Create the task.
#    Text-to-video: a prompt is all you need, no assets to host anywhere.
#    For image-to-video add:  "images": ["https://<publicly reachable>.png"]
#    (it must be a public URL — our servers fetch it, so localhost won't work).
create = requests.post(
    f"{BASE_URL}/video/generations",
    headers=HEADERS,
    json={
        "model": "veo-3.1-fast-fhd",
        "prompt": (
            "a red panda barista pulls an espresso shot, steam rising, "
            "warm morning light through the cafe window"
        ),
        "aspect_ratio": "16:9",
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
