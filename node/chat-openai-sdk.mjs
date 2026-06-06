// Chat / LLM via the official OpenAI SDK — just change baseURL.
//   npm install
//   export APIMODELS_API_KEY="sk-..."
//   node chat-openai-sdk.mjs
import OpenAI from "openai";

const client = new OpenAI({
  apiKey: process.env.APIMODELS_API_KEY,
  baseURL: "https://apimodels.app/api/v1",
});

const resp = await client.chat.completions.create({
  model: "claude-sonnet-4-6", // any LLM name from https://apimodels.app/en/docs
  messages: [
    { role: "user", content: "Explain what an API gateway is in one sentence." },
  ],
});

console.log(resp.choices[0].message.content);
