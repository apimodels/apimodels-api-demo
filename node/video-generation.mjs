// Video generation (async): create a task, then poll until it completes.
// Example: Grok Imagine Video 1.5 (Beta) — image-to-video, flat per-clip pricing.
//   export APIMODELS_API_KEY="sk-..."
//   node video-generation.mjs
const API_KEY = process.env.APIMODELS_API_KEY;
if (!API_KEY) throw new Error("Set APIMODELS_API_KEY");
const BASE_URL = "https://apimodels.app/api/v1";
const headers = { Authorization: `Bearer ${API_KEY}`, "Content-Type": "application/json" };

// 1) Create the task
const create = await fetch(`${BASE_URL}/video/generations`, {
  method: "POST",
  headers,
  body: JSON.stringify({
    model: "grok-imagine-video-1.5-beta",
    image_urls: ["https://your-domain.com/path/reference.png"],
    prompt: "the character slowly turns to camera and smiles",
    resolution: "720p",
    duration: 5, // 5 / 8 / 10 / 12 / 15
  }),
}).then((r) => r.json());

const taskId = create.data.taskId;
console.log("task:", taskId);

// 2) Poll until completed / failed
while (true) {
  const status = await fetch(`${BASE_URL}/video/generations?task_id=${taskId}`, { headers })
    .then((r) => r.json());
  const state = status.data.state;
  console.log("state:", state);
  if (state === "completed") { console.log("Video URL:", status.data.resultUrls[0]); break; }
  if (state === "failed") { throw new Error(`Generation failed: ${status.data.failMsg}`); }
  await new Promise((r) => setTimeout(r, 10000));
}
