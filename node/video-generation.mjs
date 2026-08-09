// Video generation (async): create a task, then poll until it completes.
//
// Model: veo-3.1-fast-fhd — VEO 3.1 Fast, 1080p, native audio, flat price per clip.
//
// COST: $0.07 per clip (flat — duration and resolution are fixed by the channel).
//       This is the cheapest video model we run, and it is the only one a brand-new
//       account can afford: signup credit is $0.10. Every other video model costs
//       more than the whole signup credit (grok-video-3 is $0.12 for its 6s minimum,
//       seedance-2.0-fast starts around $0.36), so those will 402 "Insufficient
//       credits" until you top up.
//
// Result URLs are kept for 7 days — download the file if you want to keep it.
//
//   export APIMODELS_API_KEY="sk-..."
//   node video-generation.mjs
const API_KEY = process.env.APIMODELS_API_KEY;
if (!API_KEY) throw new Error("Set APIMODELS_API_KEY");
const BASE_URL = "https://apimodels.app/api/v1";
const headers = { Authorization: `Bearer ${API_KEY}`, "Content-Type": "application/json" };

// 1) Create the task.
//    Text-to-video: a prompt is all you need, no assets to host anywhere.
//    For image-to-video add:  images: ["https://<publicly reachable>.png"]
//    (it must be a public URL — our servers fetch it, so localhost won't work).
const create = await fetch(`${BASE_URL}/video/generations`, {
  method: "POST",
  headers,
  body: JSON.stringify({
    model: "veo-3.1-fast-fhd",
    prompt:
      "a red panda barista pulls an espresso shot, steam rising, warm morning light through the cafe window",
    aspect_ratio: "16:9",
  }),
}).then((r) => r.json());

if (!create?.data?.taskId) throw new Error(`Create failed: ${JSON.stringify(create)}`);
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
