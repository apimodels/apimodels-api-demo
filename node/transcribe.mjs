// Speech to text (async): create a task, poll until it completes, print the text.
//
// Model: nemotron-3.5-transcribe — transcribes an audio file, or the audio track of
// a video. The result is TEXT, not a media file:
//   data.resultJson   a JSON *string*: {"task","text","duration","transcript_url",...}
//   transcript_url    the full result as a JSON file (also in data.resultUrls[0]),
//                     kept 30 days. With timestamps: true it also holds words[]
//                     (word, start, end, speaker) and diarization[].
//
// Input: audio_url must be a public URL our servers can download directly — mp3,
// wav, m4a, aac, flac, ogg, opus, webm, or an mp4 / mov with an audio track. Up to
// 60 minutes and 200 MB per file. Whole-file transcription; no realtime streaming.
//
// COST: $0.0025 per audio minute ($0.15 per hour), billed by the second. Timestamps,
//       speaker labels and translation cost nothing extra. A 1-minute clip is
//       $0.0025 — well inside the $0.10 trial credit. Failed tasks are not charged.
//
//   export APIMODELS_API_KEY="sk-..."
//   export AUDIO_URL="https://your-host/your-audio.mp3"
//   node transcribe.mjs
const API_KEY = process.env.APIMODELS_API_KEY;
if (!API_KEY) throw new Error("Set APIMODELS_API_KEY");
const AUDIO_URL = process.env.AUDIO_URL;
if (!AUDIO_URL) throw new Error("Set AUDIO_URL to a public link to your own audio or video file");
const BASE_URL = "https://api.apimodels.app/v1";
const headers = { Authorization: `Bearer ${API_KEY}`, "Content-Type": "application/json" };

// 1) Create the task.
const create = await fetch(`${BASE_URL}/audio/generations`, {
  method: "POST",
  headers,
  body: JSON.stringify({
    model: "nemotron-3.5-transcribe",
    audio_url: AUDIO_URL,
    timestamps: true, // word-level times + speaker labels (up to 8 speakers) in the transcript file
    // target_language: "en", // translate instead — cannot be combined with timestamps: true (400)
  }),
}).then((r) => r.json());

if (!create?.data?.taskId) throw new Error(`Create failed: ${JSON.stringify(create)}`);
const taskId = create.data.taskId;
console.log("task:", taskId);

// 2) Poll until completed / failed
let data;
while (true) {
  const status = await fetch(`${BASE_URL}/audio/generations?task_id=${taskId}`, { headers })
    .then((r) => r.json());
  data = status.data;
  console.log("state:", data.state);
  if (data.state === "completed") break;
  if (data.state === "failed") throw new Error(`Transcription failed: ${data.failMsg}`);
  await new Promise((r) => setTimeout(r, 3000));
}

// 3) resultJson is a JSON string — parse it once.
const result = JSON.parse(data.resultJson); // { task, text, duration, transcript_url, silent?, truncated? }
console.log(`duration: ${result.duration} s`);
if (result.silent) console.log("note: no speech was detected");
if (result.truncated) console.log("note: the result was truncated");
console.log("text:\n" + result.text);

// 4) Optional: the full result file. words[] / diarization[] exist only with timestamps: true.
console.log("transcript_url:", result.transcript_url);
const full = await fetch(result.transcript_url).then((r) => r.json());
console.log("first words:");
for (const w of (full.words ?? []).slice(0, 5)) {
  console.log(`  ${w.start}s – ${w.end}s  ${w.speaker ?? "-"}  ${w.word}`);
}
