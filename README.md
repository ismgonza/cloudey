# Cloudey.app - Your AI Cloud Intelligence & Optimization Platform

**Make smarter cloud decisions instantly—analyze costs, discover savings, optimize resources without waiting on engineers.**

## The Problem

When making budget decisions, teams need to answer "why did our cloud bill spike 40% last month?" or "what will Q2 costs look like?", but they hit a wall. They can't get answers themselves—they must create a ticket for a cloud engineer who's already juggling production incidents, feature requests, and infrastructure work.

That engineer then spends 3-8 hours writing SDK scripts or wrestling with provider consoles to extract data, transform it into something readable, and create presentations. If there are follow-up questions, the cycle repeats.

This creates a lose-lose situation: decision-makers work with stale or incomplete data, and engineers waste valuable time on repetitive reporting instead of building products. The complexity of cloud billing—with its reserved instances, spot pricing, data egress fees, and hundreds of services—means even technical teams struggle to quickly generate actionable insights.

## The Solution

Cloudey.app eliminates the engineer bottleneck by letting non-technical users ask questions in plain English and get instant, accurate answers.

Simply type:
- "Show me compute costs for the last 3 months by project"
- "Which resources are costing over $1000/month and barely used?"
- "Where can we cut costs without impacting performance?"

And receive executive-ready reports in seconds—no cloud console access needed, no SDK knowledge required, zero technical setup.

The experience feels like texting a knowledgeable colleague who instantly understands your cloud infrastructure. Behind the scenes, Cloudey's AI agents connect to your cloud account, analyze billing data, identify cost drivers, and present findings in business language with actionable recommendations.

Engineers focus on building. Decision-makers act on real-time data. Everyone makes faster, data-driven decisions.


## Current Status

**Prototype phase** - Currently supports Oracle Cloud Infrastructure (OCI) as proof of concept.

## Project Structure
```
cloudey-app/
├── backend/          # FastAPI + LangGraph agents
├── frontend/         # React + Vite interface
└── README.md         # You are here
```

See `backend/README.md` and `frontend/README.md` for setup instructions.