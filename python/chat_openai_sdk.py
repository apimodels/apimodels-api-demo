"""Chat / LLM via the official OpenAI SDK — just change base_url.

    pip install openai
    export APIMODELS_API_KEY="sk-..."
    python chat_openai_sdk.py
"""
import os
from openai import OpenAI

client = OpenAI(
    api_key=os.environ["APIMODELS_API_KEY"],
    base_url="https://apimodels.app/api/v1",
)

resp = client.chat.completions.create(
    model="claude-sonnet-4-6",  # any LLM name from https://apimodels.app/en/docs
    messages=[
        {"role": "user", "content": "Explain what an API gateway is in one sentence."},
    ],
)
print(resp.choices[0].message.content)
