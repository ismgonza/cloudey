---
alwaysApply: true
---

# Deploy order (Auth before Cloud) — ALWAYS

Cloud authenticates every request by calling Auth `POST /api/v1/internal/validate-token`.
If Cloud is live before that endpoint is live, **all authenticated Cloud routes 401/503**.

## Hard rule

**ALWAYS deploy Auth before Cloud.** Staging and production. Every time. No exceptions.

```
Auth healthy (validate-token 200 with service token)
  → then Core if it also changed
  → then Cloud + Cloud workers
```

## Do

- Merge/deploy **auth** first; wait until Auth is up and `/api/v1/internal/validate-token` exists.
- Confirm Cloud `AUTH_API_URL` points at Auth’s **private** hostname (staging: `http://auth.railway.internal:8080`).
- Only then merge/deploy **cloud** (API + workers).

## Do not

- Deploy Cloud first, or Auth and Cloud in parallel, hoping Auth wins the race.
- Treat a Cloud-only Railway redeploy as safe if Auth is still on an older revision without validate-token.
- Point `AUTH_API_URL` at Auth’s public hostname.

Rollback: roll Cloud back first (so it stops calling a bad Auth), then Auth — never leave new Cloud on old Auth.
