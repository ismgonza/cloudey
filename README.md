# Cloudey Platform

> **AI-powered cloud cost optimization that eliminates the engineer bottleneck**

**Stop waiting days for cloud cost reports. Get instant, actionable insights through natural language.**

---

## 🎯 Why Cloudey?

When decision-makers need to understand "why did our cloud bill spike 40%?" or "where can we cut $50k/month?", they hit a wall. Getting answers requires creating tickets, waiting for engineers to write custom scripts, and dealing with stale data by the time reports arrive.

**Cloudey changes this.**

Simply ask in plain English:
- *"Show me compute costs for the last 3 months by compartment"*
- *"Which resources cost over $1000/month but are barely used?"*
- *"How can I optimize my database spending?"*

Get executive-ready answers in **seconds**, not days. No cloud console access needed. No SDK knowledge required. Zero technical setup.

### The Impact

- **Decision-makers** act on real-time data instead of waiting for reports
- **Engineers** focus on building products instead of generating spreadsheets  
- **Finance teams** get instant cost breakdowns without bothering DevOps
- **Everyone** makes faster, data-driven decisions with confidence

### How It Works

Behind the scenes, Cloudey's LangGraph AI agents:
1. Connect securely to your cloud accounts
2. Analyze billing data and resource utilization (CPU, Memory, Bandwidth)
3. Identify cost drivers and optimization opportunities
4. Present findings in business language with actionable recommendations

It feels like texting a knowledgeable colleague who instantly understands your infrastructure.

---

## 🚀 Current Status

**🔨 Prototype in Active Development** 

Currently supports **Oracle Cloud Infrastructure (OCI)** as proof of concept.

**What Works Today:**
- ✅ Real-time cost tracking and analysis
- ✅ AI-powered optimization recommendations
- ✅ Natural language chat interface
- ✅ Resource inventory sync (Compute, Storage, Databases, Load Balancers)
- ✅ Utilization metrics integration (CPU, Memory, Bandwidth)
- ✅ Automated cost anomaly detection

**Coming Soon:**
- 🚧 AWS support
- 🚧 Azure support
- 🚧 User authentication & multi-tenancy
- 🚧 Cost forecasting & budget alerts

---

## 📖 About This Repository

This repository contains the **infrastructure setup** (Docker Compose) for running Cloudey locally.

---

## 📦 Repositories

This platform is split into 3 repositories:

| Repository | Description | Link |
|------------|-------------|------|
| **cloudey** | Infrastructure (Docker, docs) | 📍 You are here |
| **cloudey-backend** | FastAPI + LangGraph API | [GitHub](https://github.com/YOUR_USERNAME/cloudey-backend) |
| **cloudey-frontend** | React + Vite dashboard | [GitHub](https://github.com/YOUR_USERNAME/cloudey-frontend) |

---

## ✅ Prerequisites

Before you begin, ensure you have:

- **Docker & Docker Compose** installed
- **Node.js 18+** and **npm**
- **Python 3.11+**
- **Git**
- **OCI Account** (Oracle Cloud Infrastructure)
- **LLM API Key** (Anthropic Claude or OpenAI GPT)

---

## 🚀 Quick Start

### 1️⃣ Clone All Repositories

```bash
# Create a workspace directory
mkdir cloudey-workspace
cd cloudey-workspace

# Clone all three repositories
git clone git@github.com:YOUR_USERNAME/cloudey.git
git clone git@github.com:YOUR_USERNAME/cloudey-backend.git
git clone git@github.com:YOUR_USERNAME/cloudey-frontend.git
```

Your directory structure should look like:
```
cloudey-workspace/
├── cloudey/              # Infrastructure (this repo)
├── cloudey-backend/      # API backend
└── cloudey-frontend/     # React dashboard
```

---

### 2️⃣ Start Infrastructure Services

```bash
cd cloudey

# Start PostgreSQL + Redis
docker-compose up -d

# Verify services are running
docker ps
```

You should see:
- ✅ `cloudey-postgres` (port 5432)
- ✅ `cloudey-redis` (port 6379)

---

### 3️⃣ Set Up Backend

```bash
cd ../cloudey-backend

# Create and configure .env file
cp .env.example .env

# Edit .env and add:
# - POSTGRES_PASSWORD (from docker-compose.yml)
# - ANTHROPIC_API_KEY or OPENAI_API_KEY
# - ENCRYPTION_KEY (generate with: python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")
nano .env

# Install Python dependencies (using uv)
uv venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
uv pip install -e .

# Test database connection
python -m app.db.database

# Start backend server
uvicorn app.main:app --reload
```

Backend will be available at: **http://localhost:8000**

API documentation: **http://localhost:8000/docs**

---

### 4️⃣ Set Up Frontend

```bash
cd ../cloudey-frontend

# Install dependencies
npm install

# Create .env file
echo "VITE_API_URL=http://localhost:8000" > .env

# Start development server
npm run dev
```

Frontend will be available at: **http://localhost:3000**

---

### 5️⃣ Configure OCI Credentials

1. Open the app: http://localhost:3000
2. Click **"OCI Config"** button
3. Fill in your OCI credentials:
   - Email
   - Tenancy OCID
   - User OCID
   - Fingerprint
   - Region
   - Private Key (.pem file)
4. Click **"Save Config"**

---

### 6️⃣ Sync Your Cloud Resources

1. In the dashboard, click **"Sync Resources"**
2. Wait for the sync to complete (~2-5 minutes)
3. Navigate through the pages:
   - 🏠 **Dashboard** - Cost overview
   - 💰 **Costs Detail** - Service breakdown
   - 💡 **AI Insights** - Optimization recommendations
   - 💬 **AI Chat** - Ask questions about your infrastructure

---

## 📊 Services Overview

### PostgreSQL (Database)
- **Port:** 5432
- **Database:** cloudey
- **User:** cloudey
- **Password:** Set in `.env`

**Check database:**
```bash
# Using helper script
./check_db.sh

# Or manually
docker exec -it cloudey-postgres psql -U cloudey -d cloudey
```

### Redis (Cache)
- **Port:** 6379
- **Persistence:** Enabled (AOF)

**Check Redis:**
```bash
docker exec -it cloudey-redis redis-cli

# Inside redis-cli:
KEYS *
GET "costs:user_1:2025-10"
QUIT
```

---

## 🔧 Common Commands

### Restart Services
```bash
cd cloudey
docker-compose restart
```

### View Logs
```bash
docker-compose logs -f postgres
docker-compose logs -f redis
```

### Reset Database (⚠️ Deletes all data!)
```bash
docker-compose down -v
docker-compose up -d
```

### Stop All Services
```bash
# Stop infrastructure
docker-compose down

# Stop backend
# (Ctrl+C in terminal where uvicorn is running)

# Stop frontend
# (Ctrl+C in terminal where npm run dev is running)
```

---

## 🗂 What's in This Repository

```
cloudey/
├── docker-compose.yml       # PostgreSQL + Redis setup
├── .env.example             # Environment template
├── check_db.sh              # Database helper script
├── README.md                # This file
└── .cursor/                 # Development rules
    ├── backend.mdc
    ├── frontend.mdc
    └── general.mdc
```

---

## 📚 Documentation

For detailed documentation, see:

- **Backend Documentation:** [cloudey-backend/README.md](https://github.com/YOUR_USERNAME/cloudey-backend/blob/main/README.md)
  - API endpoints
  - Architecture details
  - Database schema
  - Troubleshooting

- **Frontend Documentation:** [cloudey-frontend/README.md](https://github.com/YOUR_USERNAME/cloudey-frontend/blob/main/README.md)
  - Component structure
  - Styling guide
  - Development workflow
  - Troubleshooting

---

## 🐛 Troubleshooting

### PostgreSQL won't start
```bash
# Check logs
docker logs cloudey-postgres

# Ensure port 5432 is not in use
lsof -i :5432

# Reset container
docker-compose down -v
docker-compose up -d postgres
```

### Redis won't start
```bash
# Check logs
docker logs cloudey-redis

# Ensure port 6379 is not in use
lsof -i :6379

# Reset container
docker-compose down -v
docker-compose up -d redis
```

### Backend can't connect to database
```bash
# Verify PostgreSQL is running
docker ps | grep postgres

# Check connection from backend
cd cloudey-backend
python -m app.db.database

# Verify .env has correct values
cat .env | grep POSTGRES
```

### Frontend can't reach backend
```bash
# Verify backend is running
curl http://localhost:8000

# Check frontend .env
cd cloudey-frontend
cat .env
# Should show: VITE_API_URL=http://localhost:8000
```

---

## 🔒 Security Notes

- 🔐 Private keys are encrypted server-side using Fernet
- 🌐 Use HTTPS in production (not included in this setup)
- 🔑 Never commit `.env` files to version control
- 👤 No authentication layer (implement JWT for production)

---

## 🚧 Current Status

**Prototype Phase** - Oracle Cloud Infrastructure (OCI) support only

### Working Features
✅ Cost tracking and analysis  
✅ AI-powered recommendations  
✅ Natural language chat  
✅ Resource inventory sync  
✅ Utilization metrics (CPU, Memory, Bandwidth)  

### Roadmap
- [ ] AWS support
- [ ] Azure support  
- [ ] User authentication
- [ ] Multi-tenancy
- [ ] Cost forecasting
- [ ] Email alerts

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

Proprietary - All rights reserved

---

## 👥 Support

For questions or issues:
- **Email:** support@cloudey.app
- **Issues:** [GitHub Issues](https://github.com/YOUR_USERNAME/cloudey/issues)

---

**Built with ❤️ by the Cloudey team**
