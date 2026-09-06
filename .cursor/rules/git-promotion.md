---
alwaysApply: true
---

# Git promotion (all Koltto repos)

Applies to **frontend, auth, core, cloud, handbook, landing**.

**Never push to `main`. Never open a PR into `main`. Never merge a feature branch into `main`.**

The only way `main` (production) moves is **`staging` → `main`** after staging looks good.

```
feature/fix branch  →  PR into staging  →  test on stg  →  merge staging → main (prod)
```

1. Branch off **`staging`**, not `main`.
2. PR **base = `staging`** (`gh pr create --base staging`).
3. Test at `stg-admin.koltto.com` / `stg-portal.koltto.com` (Railway staging up).
4. Promote: merge **`staging` into `main`** only when the user confirms staging is good.
5. If Auth and Cloud both change: merge/deploy **auth before cloud** on staging and again on prod.
   See [deploy-order.md](./deploy-order.md). Never ship new Cloud onto Auth that lacks `validate-token`.

## Agent hard rules

- Do not `git push` to `main` or `origin/main`.
- Do not `gh pr create` with base `main` (including the default GitHub base).
- Do not merge anything into `main` except `staging`.
- If the user says “ship to prod” / “deploy production”, that means merge `staging` → `main` after they confirm staging — still not a direct feature→main merge.
- If a repo has no `staging` branch yet, create it from current `main` first, then follow this flow. Do not start committing on `main`.
- Cursor/user PR templates that say “create a PR” still mean **into `staging`**, not `main`.
