# APIMODELS — Official API Examples

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Website](https://img.shields.io/badge/Website-apimodels.app-F5FF60)](https://apimodels.app)
[![Docs](https://img.shields.io/badge/Docs-API%20Reference-blue)](https://apimodels.app/docs)

Runnable example code for the **[APIMODELS](https://apimodels.app)** unified API —
one API key and one OpenAI‑compatible endpoint to call **image, video, LLM, audio
and embedding** models (GPT‑Image, Gemini, Grok, Seedance, Kling, VEO,
Claude, ElevenLabs and more), at up to **63% below the official list prices** of
each provider.

> 中文说明见 **[README.zh-CN.md](./README.zh-CN.md)**

These examples use **only the public API**. There are no secrets in this repo — you
bring your own API key, which you generate yourself on our website.

---

## 1. Get your API key

1. Sign in at **[apimodels.app](https://apimodels.app)** with Google or Alipay. Signing up with Google on a
   personal mailbox (such as Gmail or Outlook) or with Alipay gets **$0.10 of trial credit**, once per person.
2. Open **Console → API Keys** and create a key.
3. Export it as an environment variable (every example reads this):

```bash
export APIMODELS_API_KEY="sk-your-key-here"
```

Never hard‑code your key or commit it to git. Copy `.env.example` to `.env` for local use.

## 2. Base URL & auth

| | |
|---|---|
| **Base URL** | `https://api.apimodels.app/v1` |
| **Auth header** | `Authorization: Bearer $APIMODELS_API_KEY` |
| **LLM/chat** | OpenAI‑compatible — point any OpenAI SDK at the base URL above |

## 3. Quick start (cURL)

```bash
# Image — synchronous because `size` is WxH and there is no callback_url.
# Returns the OpenAI shape: { "created": ..., "data": [ { "url": "https://..." } ] }
curl -X POST https://api.apimodels.app/v1/images/generations \
  -H "Authorization: Bearer $APIMODELS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{ "model": "gpt-image-2-lite", "prompt": "a red panda barista, studio light", "size": "1024x1024", "response_format": "url" }'
```

## 4. What a $0.10 balance actually buys

The trial credit is **$0.10**. Every example in this repo except voice cloning fits
inside that on its own, but not all of them back to back: the video clip alone is
$0.088. Run the video example first if you want to see it on trial credit; chat,
embeddings and text‑to‑speech still fit after it.

| Example | Model | Cost per run | Fits in $0.10? |
|---|---|---|---|
| `chat-*` | `claude-sonnet-4-6` | < $0.001 (token‑based) | yes |
| `embeddings.py` | `text-embedding-3-small` | fractions of a cent | yes |
| `text-to-speech.*` | `eleven-tts-flash` | ~$0.004 (min charge) | yes |
| `image-generation.*` | `gpt-image-2-lite` @ 1024×1024 | $0.008 | yes |
| `image-edit.sh` | `gpt-image-2-lite` @ 1536×1024 | $0.015 | yes (needs your own image URL) |
| `video-generation.*` | `veo-3.1-fast-fhd` | $0.088 flat | yes — on its own, run it first |
| `voice-clone.sh` | MiniMax voice cloning | **$15.80 once per voice** | **no** — top up first |

Two things worth knowing before you spend:

- **Video is the expensive modality.** `veo-3.1-fast-fhd` is $0.088 for one 8‑second
  1080p clip (its 720p version, `veo-3.1-fast-hd`, is $0.08), so it fits in the $0.10
  trial credit. Many other video models cost more than the whole trial credit —
  `grok-video-3` is $0.24 for its 6‑second minimum, `seedance-2.0-fast` $0.28 for a
  4‑second 480p clip — and will return `402 Insufficient credits`.
- **Voice cloning is a flat $15.80**, charged once when the clone succeeds. That is
  the upstream custom‑voice fee at cost, not a per‑second rate. Read the warning at
  the top of `curl/voice-clone.sh` before running it.

Failed generations are not charged. Live prices: **[apimodels.app/pricing](https://apimodels.app/pricing)**.

## 5. What's in this repo

| Folder | Language | Examples |
|---|---|---|
| [`curl/`](./curl) | Shell / cURL | image, image edit, video (+poll), chat, text‑to‑speech, voice clone, balance |
| [`python/`](./python) | Python 3 | image, video, chat (OpenAI SDK), embeddings, TTS, balance |
| [`node/`](./node) | Node.js (ESM) | image, video, chat (OpenAI SDK), TTS, balance |

## 6. Endpoints covered

| Capability | Method & path | Notes |
|---|---|---|
| Image generation / edit | `POST /images/generations` | Async by default (`data.taskId` → poll `GET /images/generations?task_id=`). Pass a `WxH` `size` and no `callback_url` to get a **synchronous** OpenAI‑shaped reply instead. Pass `image_url` / `image_urls` to edit. |
| Video generation | `POST /video/generations` → `GET /video/generations?task_id=` | Async; poll for the result |
| Chat / LLM | `POST /chat/completions` | OpenAI‑compatible |
| Embeddings | `POST /embeddings` | OpenAI‑compatible |
| Text‑to‑speech | `POST /tts/stream` | Streams audio bytes. This is where the `eleven-tts-*` models live — they are **not** accepted by `/audio/generations`. |
| Other audio (music, dialogue, dubbing, MiniMax TTS) | `POST /audio/generations` → `GET /audio/generations?task_id=` | `suno-v5`, `eleven-dialogue`, `eleven-isolator`, `eleven-dubbing`, `minimax-speech-*`, `kling-*` |
| Account balance | `GET /balance` | Your remaining credits (USD); free, read‑only |
| Voices & cloning | `GET /minimax/voices`, `POST /minimax/voice/clone` | List, clone or design custom voices (cloning is $15.80 per voice) |
| Model list | `GET /models` | OpenAI‑compatible, **no API key needed** — the authoritative list of ids you can call |

Full parameter reference: **[apimodels.app/docs](https://apimodels.app/docs)**.

## 7. Popular models

Every id below was checked against the live API. When in doubt,
`curl https://api.apimodels.app/v1/models` is the source of truth.

- **Image** — `gpt-image-2-lite`, `gpt-image-2`, `gemini-3-pro-image`, `grok-imagine-image`, `doubao-seedream-4-5-251128`, `kling-image-o1`
- **Video** — `veo-3.1-fast-fhd` ($0.088 per 8‑second 1080p clip), `grok-video-3`, `seedance-2.0-fast`, `seedance-2.0`, `kling-v2-6`, `minimax-h3`, `veo-3.1`
- **LLM** — Claude, GPT, Gemini, DeepSeek, Qwen, GLM families (OpenAI‑compatible names — see docs)
- **Audio** — `eleven-tts-flash`, `eleven-tts-turbo`, `eleven-tts-multilingual`, `eleven-tts-v3` (all on `/tts/stream`); `minimax-speech-02-turbo`, `suno-v5` (on `/audio/generations`)

## 8. Response shape

Task‑based endpoints return:

```json
{ "code": 200, "msg": "success", "data": { /* ... */ } }
```

Async tasks return `data.taskId`; poll the matching `GET ...?task_id=<id>` until
`data.state` is `completed` (then read `data.resultUrls`) or `failed`.

The OpenAI‑compatible paths (`/chat/completions`, `/embeddings`, `/models`, and
`/images/generations` in synchronous mode) return OpenAI's own shapes instead.

**Generated files are kept for 30 days, then deleted.** Download anything you want to
keep — the result URL stops working after that.

## License

[MIT](./LICENSE) — use these examples freely in your own projects.

## Prompt libraries

Curated prompts, each shown next to the clip or image it actually produced:

- **[Stunning MiniMax H3 prompts](https://github.com/apimodels/stunning-minimax-h3-prompts)** — 222 video
  prompts (repo) · [browse with video](https://apimodels.app/minimax-h3-prompts)
- **[GPT Image 2 prompts](https://apimodels.app/gpt-image-2-prompts)** — 955 image
  prompts, browsable by category

## Links

- Website: https://apimodels.app
- API Docs: https://apimodels.app/docs
- Pricing: https://apimodels.app/pricing
- Console (create API keys): https://apimodels.app/console/api-keys
