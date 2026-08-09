# API Models —— 官方 API 调用示例

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Website](https://img.shields.io/badge/Website-apimodels.app-F5FF60)](https://apimodels.app)
[![Docs](https://img.shields.io/badge/Docs-API%20Reference-blue)](https://apimodels.app/zh/docs)

**[API Models](https://apimodels.app)** 统一 API 的可运行调用示例 —— 一个 API Key、
一个兼容 OpenAI 的端点,即可调用**图片、视频、大模型、语音、向量**等各家模型
(GPT‑Image、Gemini、Grok、Seedance、Kling、VEO、Claude、ElevenLabs 等),
价格比直接调用各家官方**低 60–95%**。

> English: **[README.md](./README.md)**

本仓库**只包含公开 API 的调用代码**,不含任何密钥。API Key 由你自己在我们网站上生成。

---

## 1. 获取 API Key

1. 到 **[apimodels.app](https://apimodels.app)** 注册(新用户送 **$0.10 体验额度**)。
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
# 图片 —— size 写成 宽x高 且不带 callback_url,这一次调用就是同步的,
# 直接返回 OpenAI 结构: { "created": ..., "data": [ { "url": "https://..." } ] }
curl -X POST https://apimodels.app/api/v1/images/generations \
  -H "Authorization: Bearer $APIMODELS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{ "model": "gpt-image-2-lite", "prompt": "一只在咖啡店当咖啡师的小熊猫,影棚灯光", "size": "1024x1024", "response_format": "url" }'
```

## 4. $0.10 体验额度够跑哪些示例

新账号开局是 **$0.10**。除了音色复刻,本仓库每个示例都跑得起;按下表顺序全跑一遍
还有富余:

| 示例 | 模型 | 单次花费 | $0.10 够吗 |
|---|---|---|---|
| `chat-*` | `claude-sonnet-4-6` | 不到 $0.001(按 token) | 够 |
| `embeddings.py` | `text-embedding-3-small` | 不到一分钱 | 够 |
| `text-to-speech.*` | `eleven-tts-flash` | 约 $0.004(触发最低计费) | 够 |
| `image-generation.*` | `gpt-image-2-lite` 1024×1024 | $0.008 | 够 |
| `image-edit.sh` | `gpt-image-2-lite` 1536×1024 | $0.015 | 够(但要你自己的图片外链) |
| `video-generation.*` | `veo-3.1-fast-fhd` | 每条 $0.07(固定价) | 够 —— 但只有这一个视频模型够 |
| `voice-clone.sh` | MiniMax 音色复刻 | **每个音色一次性 $15.80** | **不够**,先充值 |

花钱之前有两件事值得先知道:

- **视频是唯一的"大头"。** `veo-3.1-fast-fhd` 每条 $0.07,是新账号唯一能跑完的视频
  模型。次便宜的是 `grok-video-3`(最短 6 秒,$0.12)和 `seedance-2.0-fast`(480p 短片
  约 $0.36)—— 它们都比整个体验额度还贵,直接返回 `402 Insufficient credits`。
- **音色复刻是一口价 $15.80**,在复刻成功那一刻扣一次,不是按秒/按字计费。这是上游
  自定义音色费原样透传。跑 `curl/voice-clone.sh` 之前请先看文件开头的提示。

生成失败不扣费。实时价格见 **[apimodels.app/zh/pricing](https://apimodels.app/zh/pricing)**。

## 5. 仓库内容

| 目录 | 语言 | 示例 |
|---|---|---|
| [`curl/`](./curl) | Shell / cURL | 图片、图片编辑、视频(含轮询)、对话、语音合成、音色复刻、余额 |
| [`python/`](./python) | Python 3 | 图片、视频、对话(OpenAI SDK)、向量、TTS、余额 |
| [`node/`](./node) | Node.js (ESM) | 图片、视频、对话(OpenAI SDK)、TTS、余额 |

## 6. 覆盖的端点

| 能力 | 方法与路径 | 说明 |
|---|---|---|
| 图片生成 / 编辑 | `POST /images/generations` | 默认异步(返回 `data.taskId`,再轮询 `GET /images/generations?task_id=`)。`size` 传 `宽x高` 且不带 `callback_url` 时改为**同步**返回 OpenAI 结构。传 `image_url` / `image_urls` 即为编辑 |
| 视频生成 | `POST /video/generations` → `GET /video/generations?task_id=` | 异步,轮询取结果 |
| 对话 / 大模型 | `POST /chat/completions` | 兼容 OpenAI |
| 向量 Embedding | `POST /embeddings` | 兼容 OpenAI |
| 语音合成 TTS | `POST /tts/stream` | 流式返回音频字节。`eleven-tts-*` 系列只在这个端点上,`/audio/generations` **不收**这些名字 |
| 其它音频(音乐 / 对话 / 配音 / MiniMax TTS) | `POST /audio/generations` → `GET /audio/generations?task_id=` | `suno-v5`、`eleven-dialogue`、`eleven-isolator`、`eleven-dubbing`、`minimax-speech-*`、`kling-*` |
| 账户余额 | `GET /balance` | 查询剩余额度(美元),免费、只读 |
| 音色与复刻 | `GET /minimax/voices`、`POST /minimax/voice/clone` | 列出 / 复刻 / 设计自定义音色(复刻每个音色 $15.80) |
| 模型列表 | `GET /models` | 兼容 OpenAI,**不需要 API Key** —— 能调通的模型名以它为准 |

完整参数见:**[apimodels.app/zh/docs](https://apimodels.app/zh/docs)**。

## 7. 热门模型

下面每个名字都在线上实测过。拿不准时,以
`curl https://apimodels.app/api/v1/models` 的返回为准。

- **图片** —— `gpt-image-2-lite`、`gpt-image-2`、`gemini-3-pro-image`、`grok-imagine-image`、`doubao-seedream-4-5-251128`、`kling-image-o1`
- **视频** —— `veo-3.1-fast-fhd`(最便宜,每条 $0.07)、`grok-video-3`、`seedance-2.0-fast`、`seedance-2.0`、`kling-v2-6`、`minimax-h3`、`veo-3.1`
- **大模型** —— Claude / GPT / Gemini / DeepSeek / Qwen / GLM 系列(兼容 OpenAI 命名,见文档)
- **语音** —— `eleven-tts-flash`、`eleven-tts-turbo`、`eleven-tts-multilingual`、`eleven-tts-v3`(都走 `/tts/stream`);`minimax-speech-02-turbo`、`suno-v5`(走 `/audio/generations`)

## 8. 返回结构

任务型端点返回:

```json
{ "code": 200, "msg": "success", "data": { /* ... */ } }
```

异步任务返回 `data.taskId`;轮询对应的 `GET ...?task_id=<id>`,直到 `data.state`
为 `completed`(读 `data.resultUrls`)或 `failed`。

兼容 OpenAI 的那几条路径(`/chat/completions`、`/embeddings`、`/models`,以及同步
模式下的 `/images/generations`)返回 OpenAI 自己的结构。

**生成结果只保留 7 天**,链接过期即失效,要留的请及时下载或转存。

## 许可证

[MIT](./LICENSE) —— 可自由用于你自己的项目。

## 提示词库

每条提示词都配了它实际产出的成片或成图:

- **[Stunning MiniMax H3 提示词](https://github.com/stimQQ/stunning-minimax-h3-prompts)** —— 222 条视频
  提示词(仓库)· [配视频浏览](https://apimodels.app/minimax-h3-prompts)
- **[GPT Image 2 提示词](https://apimodels.app/gpt-image-2-prompts)** —— 955 条图像
  提示词,按类目浏览

## 链接

- 官网:https://apimodels.app
- API 文档:https://apimodels.app/zh/docs
- 价格:https://apimodels.app/zh/pricing
- 控制台(创建 API Key):https://apimodels.app/zh/console/api-keys
