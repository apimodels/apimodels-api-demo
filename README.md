# API Models — Official API Examples

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Website](https://img.shields.io/badge/Website-apimodels.app-F5FF60)](https://apimodels.app)
[![Docs](https://img.shields.io/badge/Docs-API%20Reference-blue)](https://apimodels.app/en/docs)

Runnable example code for the **[API Models](https://apimodels.app)** unified API —
one API key and one OpenAI‑compatible endpoint to call **image, video, LLM, audio
and embedding** models (GPT‑Image, Gemini, Grok Imagine, Seedance, Kling, VEO,
Claude, ElevenLabs and more), at up to **60–95% lower cost** than calling each
provider directly.

> 中文说明见 **[README.zh-CN.md](./README.zh-CN.md)**

These examples use **only the public API**. There are no secrets in this repo — you
bring your own API key, which you generate yourself on our website.

---

## 1. Get your API key

1. Sign up at **[apimodels.app](https://apimodels.app)** (new accounts get **$1 free credit**).
2. Open **Console → API Keys** and create a key.
3. Export it as an environment variable (every example reads this):

```bash
export APIMODELS_API_KEY="sk-your-key-here"
```

Never hard‑code your key or commit it to git. Copy `.env.example` to `.env` for local use.

## 2. Base URL & auth

| | |
|---|---|
| **Base URL** | `https://apimodels.app/api/v1` |
| **Auth header** | `Authorization: Bearer $APIMODELS_API_KEY` |
| **LLM/chat** | OpenAI‑compatible — point any OpenAI SDK at the base URL above |

## 3. Quick start (cURL)

```bash
# Image (synchronous — returns the image URL directly)
curl -X POST https://apimodels.app/api/v1/images/generations-sync \
  -H "Authorization: Bearer $APIMODELS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{ "model": "gpt-image-2-lite", "prompt": "a red panda barista, studio light", "size": "1024x1024" }'
```

## 4. What's in this repo

| Folder | Language | Examples |
|---|---|---|
| [`curl/`](./curl) | Shell / cURL | image, image edit, video (+poll), chat, text‑to‑speech, balance |
| [`python/`](./python) | Python 3 | image, video, chat (OpenAI SDK), embeddings, TTS, balance |
| [`node/`](./node) | Node.js (ESM) | image, video, chat (OpenAI SDK), TTS, balance |

## 5. Endpoints covered

| Capability | Method & path | Notes |
|---|---|---|
| Image generation (sync) | `POST /images/generations-sync` | Returns `resultUrls` directly |
| Image generation / edit (async) | `POST /images/generations` → `GET /images/generations?task_id=` | Pass `image` for edits |
| Video generation | `POST /video/generations` → `GET /video/generations?task_id=` | Async; poll for the result |
| Chat / LLM | `POST /chat/completions` | OpenAI‑compatible |
| Embeddings | `POST /embeddings` | OpenAI‑compatible |
| Text‑to‑speech | `POST /tts/stream` | Streams audio bytes |
| Account balance | `GET /balance` | Your remaining credits (USD); free, read‑only |
| Voices & cloning | `GET /minimax/voices`, `POST /minimax/voice/clone` | List, clone or design custom voices |

Full parameter reference and the complete, always‑current model list:
**[apimodels.app/en/docs](https://apimodels.app/en/docs)**.

## 6. Popular models

- **Image** — `gpt-image-2`, `gpt-image-2-lite`, `gemini-3-pro-image`, `grok-imagine-image`, `doubao-seedream-4-5-251128`, `kling-image-o1`
- **Video** — `grok-imagine-video-1.5`, `grok-imagine-video-1.5-beta`, `seedance-2.0`, `seedance-2.0-fast`, `kling-v2-6`, `veo-3.1`
- **LLM** — Claude, GPT, Gemini families (OpenAI‑compatible names — see docs)
- **Audio** — `eleven-tts-flash`, `eleven-tts-multilingual`, `eleven-tts-v3`

See live pricing at **[apimodels.app/en/pricing](https://apimodels.app/en/pricing)**.

## 7. Response shape

Most REST endpoints return:

```json
{ "code": 200, "msg": "success", "data": { /* ... */ } }
```

Async tasks return `data.taskId`; poll the matching `GET ...?task_id=<id>` until
`data.state` is `completed` (then read `data.resultUrls`) or `failed`.

## License

[MIT](./LICENSE) — use these examples freely in your own projects.

## Links

- 🌐 Website: https://apimodels.app
- 📖 API Docs: https://apimodels.app/en/docs
- 💳 Pricing: https://apimodels.app/en/pricing
- 🔑 Console (create API keys): https://apimodels.app/en/console/api-keys
