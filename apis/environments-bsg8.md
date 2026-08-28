# Environments — Pilates Exercises API

| Key | Name | URL | Notes |
|-----|------|-----|-------|
| development | Development | `http://localhost:8128` | Local `./run.sh` or Uvicorn |
| production | Production | `http://56.228.38.227:8128` | PM2 process `pilates-exercises-app` |

## Runtime evidence

- **Production URL:** `http://56.228.38.227:8128`
- **GitHub:** https://github.com/sohailtahir5858/pilates-exercises-app
- Bind: `0.0.0.0:8128` (`run.sh`)
- No Docker / no GitHub Actions / no Terraform in repo
- Region default for S3: `eu-north-1`
- Catalogue DB: PostgreSQL via `DATABASE_URL`
- Seed: `python scripts/seed_pilates.py` from `data/pilates.json`

## Env var key names (no values)

`API_KEY`, `OPENAI_API_KEY`, `APP_SIGNATURE_SECRET`, `ENFORCE_APP_SIGNATURE`, `ENFORCE_RATE_LIMIT`, `RATE_LIMIT_*`, `REQUEST_TIMEOUT_*`, `AWS_*`, `S3_*`, `MAX_UPLOAD_BYTES`, `ALLOWED_IMAGE_CONTENT_TYPES`, `DATABASE_URL`, `PILATES_SEED_PATH`, `CATALOGUE_CACHE_MAX_AGE_SECONDS`
