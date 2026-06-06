// Text-to-speech — streams audio bytes; save them to an .mp3 file.
//   export APIMODELS_API_KEY="sk-..."
//   node text-to-speech.mjs
import { writeFile } from "node:fs/promises";

const API_KEY = process.env.APIMODELS_API_KEY;
if (!API_KEY) throw new Error("Set APIMODELS_API_KEY");
const BASE_URL = "https://apimodels.app/api/v1";

const res = await fetch(`${BASE_URL}/tts/stream`, {
  method: "POST",
  headers: { Authorization: `Bearer ${API_KEY}`, "Content-Type": "application/json" },
  body: JSON.stringify({
    model: "eleven-tts-flash",
    text: "Hello from API Models. This audio was generated through one unified API.",
    // voice_id: "21m00Tcm4TlvDq8ikWAM", // optional
  }),
});

const buf = Buffer.from(await res.arrayBuffer());
await writeFile("speech.mp3", buf);
console.log("saved -> speech.mp3");
