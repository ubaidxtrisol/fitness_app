# Authentication — Pilates Exercises API

See also root `AUTHENTICATION_PROCESS.md`.

## Layers

1. **API key (enforced)** — header `X-API-KEY` on all routes except `GET /health`
2. **App signature (implemented, off by default)** — `X-App-Timestamp`, `X-App-Nonce`, `X-App-Signature` when `ENFORCE_APP_SIGNATURE=true`

## Rate limits (defaults)

| Type | Max / window | Block after strikes |
|------|--------------|---------------------|
| scan (`POST /api/v1/scan/pose`) | 5 / 60s | 2 strikes → 86400s IP block |
| text (pilates + recommend) | 20 / 60s | 2 strikes → 86400s IP block |

## Timeouts

- Text routes: 60s (`REQUEST_TIMEOUT_SECONDS`)
- Scan routes: 90s (`REQUEST_TIMEOUT_SCAN_SECONDS`)
- Health: no timeout middleware path special-case

Swagger/OpenAPI URLs are disabled in `app/main.py`.
