"""Video generation (async): create a task, then poll until it completes.

Model: veo-3.1-fast-fhd — VEO 3.1 Fast, 1080p, native audio, flat price per clip.

COST: $0.07 per clip (flat — duration and resolution are fixed by the channel).
      This is the cheapest video model we run, and it is the only one a brand-new
      account can afford: signup credit is $0.10. Every other video model costs
      more than the whole signup credit (grok-video-3 is $0.12 for its 6s minimum,
      seedance-2.0-fast starts around $0.36), so those will 402 "Insufficient
      credits" until you top up.

Result URLs are kept for 7 days — download the file if you want to keep it.

    export APIMODELS_API_KEY="sk-..."
    python video_generation.py
"""
import os
import time
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
BASE_URL = "https://apimodels.app/api/v1"
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
