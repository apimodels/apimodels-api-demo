// Image generation (synchronous) — returns the image URL(s) directly.
//   export APIMODELS_API_KEY="sk-..."
//   node image-generation.mjs
const API_KEY = process.env.APIMODELS_API_KEY;
if (!API_KEY) throw new Error("Set APIMODELS_API_KEY (https://apimodels.app/en/console/api-keys)");
const BASE_URL = "https://apimodels.app/api/v1";

const res = await fetch(`${BASE_URL}/images/generations-sync`, {
  method: "POST",
  headers: { Authorization: `Bearer ${API_KEY}`, "Content-Type": "application/json" },
  body: JSON.stringify({
    model: "gpt-image-2-lite",
    prompt: "A red panda barista pulling an espresso shot, studio lighting",
    size: "1024x1024",
  }),
});

const data = await res.json();
console.log("Image URL:", data.data.resultUrls[0]);
