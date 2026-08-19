---
alwaysApply: true
---

# Frontend — Vercel deployment & optimization

Applies to the **frontend** repo (React + Vite SPA deployed on Vercel).

## Pre-push build gate

Before pushing any frontend branch or opening a PR, **always** run the production
build locally and fix every error:

```bash
cd frontend && npm run build   # tsc -b && vite build
```

Common pitfalls that break Vercel but pass `tsc --noEmit`:
- Unused imports/variables (`noUnusedLocals`, `noUnusedParameters` in tsconfig).
- Type-only imports that should use `import type` (`verbatimModuleSyntax`).
- Missing exports referenced by other files in the project references graph.

Never push hoping Vercel will catch the error — catch it yourself first.

## TypeScript strictness

The frontend uses strict TS settings in `tsconfig.app.json`:
- `noUnusedLocals: true` — every declared local must be used.
- `noUnusedParameters: true` — every function parameter must be used (prefix with `_` if intentionally unused).
- `verbatimModuleSyntax: true` — type-only imports must use `import type`.
- `noFallthroughCasesInSwitch: true`.

When refactoring, always clean up symbols that become unused.

## Vite / React SPA optimization checklist

Apply these when writing or reviewing frontend code:

### Bundle size
- Import directly from modules, not barrel `index.ts` re-exports.
- Lazy-load heavy routes with `React.lazy()` + `Suspense` (the app already uses
  react-router-dom — split at route level).
- Avoid importing large libraries in components that render on every page.
- Check `npm run build` output: warn if any chunk exceeds 500 kB gzip.

### Re-render performance
- Derive state during render instead of `useEffect` + `setState`.
- Use `useMemo` / `useCallback` only when the computation is expensive or the
  value is passed as a prop to memoized children.
- Never define components inside other components.
- Prefer primitive dependencies in `useEffect` / `useMemo` dep arrays.

### Data fetching
- Use `Promise.all()` for independent parallel requests.
- Avoid request waterfalls: don't `await` one fetch before starting another
  when they are independent.

### Assets & caching
- Vite fingerprints all assets in `dist/assets/` — Vercel serves them with
  immutable cache headers automatically. No extra config needed.
- For API responses, rely on backend `Cache-Control` headers; do not cache
  auth-sensitive data on the client.

## Vercel project settings

- The frontend deploys as a **static SPA** (Vite build output in `dist/`).
- Preview deployments run on every push; production deploys only from `main`.
- `staging` branch gets preview deployments used for QA.
- Environment variable `VITE_API_URL` is set per Vercel environment to point
  at the correct API gateway.
- No serverless functions — all API calls go to the separate backend services.

## After a Vercel build failure

1. Pull the build logs: use the Vercel MCP `get_deployment_build_logs` tool
   with `errorsOnly: true`.
2. Fix locally, verify with `npm run build`, then push the fix.
3. Never retry a deploy without fixing the root cause first.
