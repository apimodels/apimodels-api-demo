# API Models —— 官方 API 调用示例

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Website](https://img.shields.io/badge/Website-apimodels.app-F5FF60)](https://apimodels.app)
[![Docs](https://img.shields.io/badge/Docs-API%20Reference-blue)](https://apimodels.app/zh/docs)

**[API Models](https://apimodels.app)** 统一 API 的可运行调用示例 —— 一个 API Key、
一个兼容 OpenAI 的端点,即可调用**图片、视频、大模型、语音、向量**等各家模型
(GPT‑Image、Gemini、Grok Imagine、Seedance、Kling、VEO、Claude、ElevenLabs 等),
价格比直接调用各家官方**低 60–95%**。

> English: **[README.md](./README.md)**

本仓库**只包含公开 API 的调用代码**,不含任何密钥。API Key 由你自己在我们网站上生成。

---

## 1. 获取 API Key

1. 到 **[apimodels.app](https://apimodels.app)** 注册(新用户送 **$1 体验额度**)。
2. 进入 **控制台 → API Keys**,创建一个 Key。
3. 设为环境变量(所有示例都读它):

```bash
export APIMODELS_API_KEY="sk-你的key"
```

切勿把 Key 硬编码或提交到 git。本地使用请把 `.env.example` 复制为 `.env`。

## 2. 基础地址与鉴权

| | |
|---|---|
| **Base URL** | `https://apimodels.app/api/v1` |
| **鉴权头** | `Authorization: Bearer $APIMODELS_API_KEY` |
| **大模型/对话** | 兼容 OpenAI —— 把任意 OpenAI SDK 的 base_url 指到上面即可 |

## 3. 快速开始(cURL)

```bash
# 图片(同步 —— 直接返回图片 URL)
curl -X POST https://apimodels.app/api/v1/images/generations-sync \
  -H "Authorization: Bearer $APIMODELS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{ "model": "gpt-image-2-lite", "prompt": "一只在咖啡店当咖啡师的小熊猫,影棚灯光", "size": "1024x1024" }'
```

## 4. 仓库内容

| 目录 | 语言 | 示例 |
|---|---|---|
| [`curl/`](./curl) | Shell / cURL | 图片、图片编辑、视频(含轮询)、对话、语音合成、余额 |
| [`python/`](./python) | Python 3 | 图片、视频、对话(OpenAI SDK)、向量、TTS、余额 |
| [`node/`](./node) | Node.js (ESM) | 图片、视频、对话(OpenAI SDK)、TTS、余额 |

## 5. 覆盖的端点

| 能力 | 方法与路径 | 说明 |
|---|---|---|
| 图片生成(同步) | `POST /images/generations-sync` | 直接返回 `resultUrls` |
| 图片生成/编辑(异步) | `POST /images/generations` → `GET /images/generations?task_id=` | 传 `image` 即为编辑 |
| 视频生成 | `POST /video/generations` → `GET /video/generations?task_id=` | 异步,轮询取结果 |
| 对话 / 大模型 | `POST /chat/completions` | 兼容 OpenAI |
| 向量 Embedding | `POST /embeddings` | 兼容 OpenAI |
| 语音合成 TTS | `POST /tts/stream` | 流式返回音频字节 |
| 账户余额 | `GET /balance` | 查询剩余额度(美元),免费、只读 |
| 音色与复刻 | `GET /minimax/voices`、`POST /minimax/voice/clone` | 列出 / 复刻 / 设计自定义音色 |

完整参数与**始终最新的模型清单**见:**[apimodels.app/zh/docs](https://apimodels.app/zh/docs)**。

## 6. 热门模型

- **图片** —— `gpt-image-2`、`gpt-image-2-lite`、`gemini-3-pro-image`、`grok-imagine-image`、`doubao-seedream-4-5-251128`、`kling-image-o1`
- **视频** —— `grok-imagine-video-1.5`、`grok-imagine-video-1.5-beta`、`seedance-2.0`、`seedance-2.0-fast`、`kling-v2-6`、`veo-3.1`
- **大模型** —— Claude / GPT / Gemini 系列(兼容 OpenAI 命名,见文档)
- **语音** —— `eleven-tts-flash`、`eleven-tts-multilingual`、`eleven-tts-v3`

实时价格见 **[apimodels.app/zh/pricing](https://apimodels.app/zh/pricing)**。

## 7. 返回结构

多数 REST 端点返回:

```json
{ "code": 200, "msg": "success", "data": { /* ... */ } }
```

异步任务返回 `data.taskId`;轮询对应的 `GET ...?task_id=<id>`,直到 `data.state`
为 `completed`(读 `data.resultUrls`)或 `failed`。

## 许可证

[MIT](./LICENSE) —— 可自由用于你自己的项目。

## 提示词库

每条提示词都配了它实际产出的成片或成图:

- **[MiniMax H3 提示词](https://github.com/stimQQ/minimax-h3-prompts)** —— 135 条视频
  提示词(仓库)· [配视频浏览](https://apimodels.app/minimax-h3-prompts)
- **[GPT Image 2 提示词](https://apimodels.app/gpt-image-2-prompts)** —— 957 条图像
  提示词,按类目浏览

## 链接

- 🌐 官网:https://apimodels.app
- 📖 API 文档:https://apimodels.app/zh/docs
- 💳 价格:https://apimodels.app/zh/pricing
- 🔑 控制台(创建 API Key):https://apimodels.app/zh/console/api-keys
