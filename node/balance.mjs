// Account balance — query your available credit balance (USD).
// Read-only; never charges credits.
//   export APIMODELS_API_KEY="sk-..."
//   node balance.mjs
const API_KEY = process.env.APIMODELS_API_KEY;
if (!API_KEY) throw new Error("Set APIMODELS_API_KEY");
const BASE_URL = "https://api.apimodels.app/v1";

const res = await fetch(`${BASE_URL}/balance`, {
  headers: { Authorization: `Bearer ${API_KEY}` },
});
const { data } = await res.json();
console.log(`Available: ${data.balance} ${data.currency}`);
console.log(`Total: ${data.total}  Frozen: ${data.frozen}`);
