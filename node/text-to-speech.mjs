// Text-to-speech — streams audio bytes; save them to an .mp3 file.
//
// ElevenLabs TTS lives on POST /tts/stream (NOT /audio/generations — that endpoint
// does not accept eleven-tts-* ids). Valid models: eleven-tts-flash, eleven-tts-turbo,
// eleven-tts-multilingual, eleven-tts-v3.
//
// COST: $0.0425 per 1000 characters on flash/turbo ($0.085 on multilingual/v3), with
//       a minimum charge of one tenth of that. The line below bills about $0.004 —
//       well inside the $0.10 signup credit.
//
//   export APIMODELS_API_KEY="sk-..."
//   node text-to-speech.mjs
import { writeFile } from "node:fs/promises";

const API_KEY = process.env.APIMODELS_API_KEY;
if (!API_KEY) throw new Error("Set APIMODELS_API_KEY");
const BASE_URL = "https://api.apimodels.app/v1";

const res = await fetch(`${BASE_URL}/tts/stream`, {
  method: "POST",
  headers: { Authorization: `Bearer ${API_KEY}`, "Content-Type": "application/json" },
  body: JSON.stringify({
    model: "eleven-tts-flash",
    text: "Hello from API Models. This audio was generated through one unified API.",
    // voice_id: "21m00Tcm4TlvDq8ikWAM", // optional
  }),
});

if (!res.ok) throw new Error(`TTS failed: ${await res.text()}`);

const buf = Buffer.from(await res.arrayBuffer());
await writeFile("speech.mp3", buf);
console.log("saved -> speech.mp3");
