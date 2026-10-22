"""Text-to-speech — streams audio bytes; save them to an .mp3 file.

ElevenLabs TTS lives on POST /tts/stream (NOT /audio/generations — that endpoint
does not accept eleven-tts-* ids). Valid models: eleven-tts-flash, eleven-tts-turbo,
eleven-tts-multilingual, eleven-tts-v3.

COST: $0.0425 per 1000 characters on flash/turbo ($0.085 on multilingual/v3), with
      a minimum charge of one tenth of that. The call below bills about $0.004 —
      well inside the $0.10 signup credit.

    export APIMODELS_API_KEY="sk-..."
    python text_to_speech.py
"""
import os
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
BASE_URL = "https://api.apimodels.app/v1"

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
