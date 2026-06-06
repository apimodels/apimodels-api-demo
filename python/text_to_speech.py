"""Text-to-speech — streams audio bytes; save them to an .mp3 file.

    export APIMODELS_API_KEY="sk-..."
    python text_to_speech.py
"""
import os
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
BASE_URL = "https://apimodels.app/api/v1"

with requests.post(
    f"{BASE_URL}/tts/stream",
    headers={"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"},
    json={
        "model": "eleven-tts-flash",
        "text": "Hello from API Models. This audio was generated through one unified API.",
        # "voice_id": "21m00Tcm4TlvDq8ikWAM",  # optional
    },
    stream=True,
    timeout=180,
) as r:
    r.raise_for_status()
    with open("speech.mp3", "wb") as f:
        for chunk in r.iter_content(chunk_size=8192):
            f.write(chunk)

print("saved -> speech.mp3")
