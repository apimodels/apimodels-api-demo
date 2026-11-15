"""Speech to text (async): create a task, poll until it completes, print the text.

Model: nemotron-3.5-transcribe — transcribes an audio file, or the audio track of
a video. The result is TEXT, not a media file:
  data.resultJson   a JSON *string*: {"task","text","duration","transcript_url",...}
  transcript_url    the full result as a JSON file (also in data.resultUrls[0]),
                    kept 30 days. With timestamps=True it also holds words[]
                    (word, start, end, speaker) and diarization[].

Input: audio_url must be a public URL our servers can download directly — mp3,
wav, m4a, aac, flac, ogg, opus, webm, or an mp4 / mov with an audio track. Up to
60 minutes and 200 MB per file. Whole-file transcription; no realtime streaming.

COST: $0.0025 per audio minute ($0.15 per hour), billed by the second. Timestamps,
      speaker labels and translation cost nothing extra. A 1-minute clip is
      $0.0025 — well inside the $0.10 trial credit. Failed tasks are not charged.

    export APIMODELS_API_KEY="sk-..."
    export AUDIO_URL="https://your-host/your-audio.mp3"
    python transcribe.py
"""
import json
import os
import time
import requests

API_KEY = os.environ["APIMODELS_API_KEY"]
AUDIO_URL = os.environ["AUDIO_URL"]  # a public link to your own audio or video file
BASE_URL = "https://api.apimodels.app/v1"
HEADERS = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}

# 1) Create the task.
create = requests.post(
    f"{BASE_URL}/audio/generations",
    headers=HEADERS,
    json={
        "model": "nemotron-3.5-transcribe",
        "audio_url": AUDIO_URL,
        "timestamps": True,  # word-level times + speaker labels (up to 8 speakers) in the transcript file
        # "target_language": "en",  # translate instead — cannot be combined with timestamps=True (400)
    },
    timeout=60,
)
create.raise_for_status()
task_id = create.json()["data"]["taskId"]
print("task:", task_id)

# 2) Poll until completed / failed
while True:
    data = requests.get(
        f"{BASE_URL}/audio/generations",
        headers=HEADERS,
        params={"task_id": task_id},
        timeout=60,
    ).json()["data"]
    print("state:", data["state"])
    if data["state"] == "completed":
        break
    if data["state"] == "failed":
        raise SystemExit(f"Transcription failed: {data.get('failMsg')}")
    time.sleep(3)

# 3) resultJson is a JSON string — parse it once.
result = json.loads(data["resultJson"])  # {task, text, duration, transcript_url, silent?, truncated?}
print(f"duration: {result['duration']} s")
if result.get("silent"):
    print("note: no speech was detected")
if result.get("truncated"):
    print("note: the result was truncated")
print("text:\n" + result["text"])

# 4) Optional: the full result file. words[] / diarization[] exist only with timestamps=True.
print("transcript_url:", result["transcript_url"])
full = requests.get(result["transcript_url"], timeout=60).json()
print("first words:")
for w in full.get("words", [])[:5]:
    print(f"  {w['start']}s – {w['end']}s  {w.get('speaker', '-')}  {w['word']}")
