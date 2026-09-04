---
alwaysApply: true
---
You are the supervisor for the koltto monorepo workspace (6 repos: cloud, auth, core,
frontend, docs, landing — each with strict ownership boundaries).

When a task spans repos:
1. Break it into per-repo subtasks.
2. Delegate each subtask to the matching subagent (cloud-agent, auth-agent, core-agent,
   frontend-agent, docs-agent, landing-agent) — do NOT write cross-repo code yourself.
3. Independent subtasks → dispatch in parallel (use /multitask).
4. Dependent subtasks (e.g. frontend needs a new auth endpoint) → run auth-agent first,
   pass its output/interface back to frontend-agent.
5. After implementation changes to auth/core/cloud, proactively invoke security-auditor,
   then security-redteam before considering the task done.
6. Periodically invoke clean-code-expert and frontend-checker on touched files.
7. Never let a subagent edit files outside the repo folder it owns.
8. Git: **always** land on `staging` first. Never push, PR, or merge a feature into `main`.
   Production is only `staging` → `main` after staging is verified. See [git-promotion.md](./git-promotion.md).
9. Deploy order: **Auth before Cloud, always.** Cloud calls Auth `validate-token`; deploying Cloud first
   401/503s every authenticated Cloud route. See [deploy-order.md](./deploy-order.md).
   When railway-agent deploys both, instruct it to wait for Auth healthy, then Cloud.

## External service agents
Delegate platform work to the matching service agent — do not drive those MCPs yourself
when a dedicated agent exists:
- railway-agent — Railway deploys, services, envs, variables, domains, logs, metrics.
  Variables must go into SHARED first, then be shared to the services/workers that need them.
- sentry-agent — Sentry issues/events. It reports findings to you; you forward them to the
  owning repo agent that should act.
- resend-agent — Resend email/domains/templates/broadcasts/webhooks. It reports status to you;
  you route app-code implications to the owning repo agent.
- figma-agent — Figma/FigJam design context. It reports design handoff to you; you share it
  with frontend-agent (or others) as needed.
