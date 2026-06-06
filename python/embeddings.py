"""Text embeddings via the official OpenAI SDK — OpenAI-compatible endpoint.

    pip install openai
    export APIMODELS_API_KEY="sk-..."
    python embeddings.py
"""
import os
from openai import OpenAI

client = OpenAI(
    api_key=os.environ["APIMODELS_API_KEY"],
    base_url="https://apimodels.app/api/v1",
)

resp = client.embeddings.create(
    model="text-embedding-3-small",  # see docs for available embedding models
    input="API Models gives you one key for every model.",
)
vec = resp.data[0].embedding
print(f"dimensions: {len(vec)}")
print("first 5 values:", vec[:5])
