// Image generation — synchronous, OpenAI-compatible.
//
// POST /images/generations with a WxH `size` and no `callback_url` makes the call
// synchronous: it waits for the image and returns the OpenAI shape
//   { created, data: [ { url } ] }
// Drop `size` (or add `callback_url`) and the same endpoint becomes async instead,
// returning { code, data: { taskId, state } } which you poll with
// GET /images/generations?task_id=<id>.
//
// COST: $0.008 at 1024x1024 (gpt-image-2-lite, 1K tier). 2K is $0.015, 4K $0.025.
//       Comfortably inside the $0.10 trial credit.
//
// Result files are kept for 30 days, then deleted — download the file if you want
// to keep it.
//
//   export APIMODELS_API_KEY="sk-..."
//   node image-generation.mjs
const API_KEY = process.env.APIMODELS_API_KEY;
if (!API_KEY) throw new Error("Set APIMODELS_API_KEY (https://apimodels.app/console/api-keys)");
const BASE_URL = "https://api.apimodels.app/v1";

const res = await fetch(`${BASE_URL}/images/generations`, {
  method: "POST",
  headers: { Authorization: `Bearer ${API_KEY}`, "Content-Type": "application/json" },
  body: JSON.stringify({
    model: "gpt-image-2-lite",
    prompt: "A red panda barista pulling an espresso shot, studio lighting",
    size: "1024x1024",
    response_format: "url", // omit to also get b64_json inline
  }),
});

const data = await res.json();
if (!res.ok) throw new Error(`Generation failed: ${JSON.stringify(data)}`);
console.log("Image URL:", data.data[0].url);
