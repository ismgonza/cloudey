# 🎭 Demo Mode - Complete Guide

## Overview

**Simple backend middleware** that anonymizes ALL API responses for secure presentations. Works everywhere automatically - dashboard, costs page, AI chat, everything.

**Key Benefits:**
- ✅ ONE file controls everything (`backend/app/demo_middleware.py`)
- ✅ Works for ALL pages including AI chat
- ✅ Easy to enable/disable with environment variable
- ✅ Easy to rollback (delete one file, remove 2 lines)
- ✅ Consistent anonymization everywhere

---

## Quick Start

### Enable Demo Mode

```bash
# In your backend terminal
export DEMO_MODE=true
uv run uvicorn app.main:app --reload
```

OR add to your `.env` file:
```bash
DEMO_MODE=true
```

**That's it!** All API responses are now anonymized.

### Cost Obfuscation Strategies (Optional)

Choose how to transform costs:

**Option 1: Multiply by 2 (recommended for hiding scale)**
```bash
export DEMO_MODE=true
export DEMO_COST_STRATEGY=multiply
export DEMO_COST_MULTIPLIER=2.0
```

**Option 2: Add constant offset**
```bash
export DEMO_MODE=true
export DEMO_COST_STRATEGY=add
export DEMO_COST_ADDITION=1234.0
```

**Option 3: Reduce by percentage (default)**
```bash
export DEMO_MODE=true
export DEMO_COST_STRATEGY=reduce
export DEMO_COST_MULTIPLIER=0.85  # 15% reduction
```

### Disable Demo Mode

```bash
# Remove environment variable
unset DEMO_MODE

# Or just restart without it
uv run uvicorn app.main:app --reload
```

---

## What Gets Anonymized

| Type | Before | After |
|------|--------|-------|
| **Compartment** | `production_east` | `compartment-abc12345` |
| **Compartment** | `staging_west` | `compartment-xyz67890` |
| **Instance Name** | `web-server-prod-01` | `instance-def45678` |
| **Volume Name** | `database_storage_prod` | `volume-ghi78901` |
| **Load Balancer** | `public_lb_prod` | `loadbalancer-jkl23456` |
| **Cost** | `$125,000.00` | Depends on strategy (see below) |

**Cost Transformation Strategies:**
- **Multiply** (default): `$125,000 * 2 = $250,000` (hides real scale)
- **Add**: `$125,000 + $1,234 = $126,234` (shifts all values)
- **Reduce**: `$125,000 * 0.85 = $106,250` (~15% reduction)

**Format:** `{resource_type}-{last_8_chars_of_ocid}`

**Benefits:**
- ✅ Same OCID = same anonymized name (consistent everywhere)
- ✅ Works in AI chat without complex text replacement
- ✅ Looks professional and generic
- ✅ Simple to implement and maintain
- ✅ Flexible cost obfuscation strategies

**What Stays the Same:**
- Resource counts (shows scale)
- Percentages (shows trends) 
- Sizes (GB, vCPUs, etc.)
- States (RUNNING, STOPPED, etc.)
- Service names (Compute, Storage, etc.)
- Regions (technical data)

---

## How It Works

```
Request → Backend API → Database (real data) → Response
                                                    ↓
                                          Demo Middleware
                                                    ↓
                                          (if DEMO_MODE=true)
                                                    ↓
                                          Anonymize JSON
                                                    ↓
                                          Frontend ← Anonymized Data
```

**One middleware intercepts ALL responses:**
- Dashboard data → Anonymized
- Detailed costs → Anonymized
- Recommendations → Anonymized
- **AI Chat responses → Anonymized** ✅
- Everything → Anonymized

---

## Files Changed

### New Files Created:

**`backend/app/demo_middleware.py`** (~200 lines)
- Main anonymization logic
- Middleware class that intercepts all HTTP responses
- Simple OCID-based naming (`instance-abc12345` format)
- Cost obfuscation (multiply by 0.85)

### Modified Files:

**`backend/app/main.py`** (3 lines added)
```python
# Line 19: Import
from app.demo_middleware import DemoModeMiddleware, DEMO_MODE

# Line 71: Add middleware
app.add_middleware(DemoModeMiddleware)

# Lines 72-75: Log if active
if DEMO_MODE:
    logger.warning("🎭 DEMO MODE ACTIVE - All API responses will be anonymized!")
```

**`backend/app/cloud/oci/ai_cache_tools.py`** (Added demo mode support)
- Added `DEMO_MODE` check at top of file
- Added `anonymize_for_demo()` function
- Applied anonymization to all 5 AI tools before they return data:
  - `query_cached_costs`
  - `get_top_cost_drivers`
  - `query_resource_inventory`
  - `get_resources_with_costs`
  - `get_volumes_with_details`

### Frontend Files:

No frontend changes needed! Frontend just displays whatever the backend sends (clean and simple).

---

## Testing

### 1. Enable Demo Mode

```bash
cd backend
export DEMO_MODE=true
uv run uvicorn app.main:app --reload
```

You should see in the terminal:
```
================================================================================
🎭 DEMO MODE ACTIVE - All API responses will be anonymized!
================================================================================
```

### 2. Check Dashboard

Open `http://localhost:3000` and verify:
- ✅ No real compartment names (should see generic anonymized names)
- ✅ Costs are different (~15% lower)
- ✅ Top compartments show as "compartment-abc12345", "compartment-xyz67890", etc.

### 3. Check Detailed Costs

Go to Costs page and verify:
- ✅ Compartment column shows "compartment-abc12345", "compartment-xyz67890", etc.
- ✅ Resource names show as "instance-abc12345", "volume-def67890", etc.
- ✅ Costs are obfuscated

### 4. Check AI Chat (IMPORTANT!)

Ask: "Show me the top 5 most expensive resources"

The AI should return readable responses with anonymized names like:
- ✅ `instance-abc12345` - $X,XXX.XX
- ✅ `volume-def67890` - $X,XXX.XX
- ✅ `compartment-xyz45678`

**Note:** AI chat will show the same anonymized format consistently across all responses.

---

## Rollback Instructions

If you need to completely remove demo mode:

### Step 1: Delete Middleware File

```bash
rm backend/app/demo_middleware.py
```

### Step 2: Revert main.py Changes

Edit `backend/app/main.py` and remove these lines:

**Line ~19** (remove import):
```python
from app.demo_middleware import DemoModeMiddleware, DEMO_MODE
```

**Lines ~70-75** (remove middleware):
```python
# Add Demo Mode Middleware (anonymizes ALL responses when DEMO_MODE=true)
app.add_middleware(DemoModeMiddleware)
if DEMO_MODE:
    logger.warning("=" * 80)
    logger.warning("🎭 DEMO MODE ACTIVE - All API responses will be anonymized!")
    logger.warning("=" * 80)
```

### Step 3: Revert ai_cache_tools.py Changes

Edit `backend/app/cloud/oci/ai_cache_tools.py`:

**Remove at top of file (lines ~8-30)**:
```python
import os

# Check if demo mode is active
DEMO_MODE = os.getenv("DEMO_MODE", "false").lower() == "true"

# Import demo mode functions if active
if DEMO_MODE:
    from app.demo_middleware import anonymize_compartment, anonymize_resource_name, obfuscate_cost


def anonymize_for_demo(data):
    """Apply demo mode anonymization to tool outputs"""
    # ... entire function (lines 33-56)
```

**Remove anonymization calls from all tools**:

Search for these lines and remove them (5 occurrences):
```python
# Apply demo mode anonymization to costs data
costs = anonymize_for_demo(costs)
```
```python
# Apply demo mode anonymization to top costs data
top_costs = anonymize_for_demo(top_costs)
```
```python
# Apply demo mode anonymization to results
results = anonymize_for_demo(results)
```
```python
# Apply demo mode anonymization to resources
resources = anonymize_for_demo(resources)
# Anonymize costs in resource_costs dict
if DEMO_MODE:
    resource_costs = {k: {m: obfuscate_cost(v) for m, v in months.items()} for k, months in resource_costs.items()}
```
```python
# Apply demo mode anonymization to volume data
volume_costs = anonymize_for_demo(volume_costs)
```

### Step 4: Restart Backend

```bash
uv run uvicorn app.main:app --reload
```

**Done!** You're back to real data everywhere.

---

## Advantages of This Approach

### vs Frontend-Only Approach:

| Aspect | Frontend-Only | Backend Middleware |
|--------|--------------|-------------------|
| **Complexity** | High (patch every component) | Low (one file) |
| **AI Chat** | ❌ Doesn't work | ✅ Works automatically |
| **Coverage** | ⚠️ Easy to miss spots | ✅ Everything anonymized |
| **Maintenance** | ❌ Hard to maintain | ✅ Easy to maintain |
| **Rollback** | ⚠️ Multiple files to revert | ✅ Delete 1 file, remove 3 lines |

### Why It's Simple:

1. **ONE file** (`demo_middleware.py`) controls everything
2. **ONE toggle** (environment variable)
3. **Works everywhere** (frontend, AI, APIs, everything)
4. **Easy rollback** (delete file, remove 2 lines)

---

## Customization

### Cost Obfuscation Settings (via Environment Variables)

**No code changes needed!** Just set environment variables:

```bash
# Choose strategy
export DEMO_COST_STRATEGY=multiply  # or "add" or "reduce"

# For multiply strategy
export DEMO_COST_MULTIPLIER=2.0     # 2x all costs (default)

# For add strategy  
export DEMO_COST_ADDITION=1234.0    # +$1234 to all costs

# For reduce strategy
export DEMO_COST_MULTIPLIER=0.85    # 15% reduction
```

**Examples:**
- Hide scale: `DEMO_COST_STRATEGY=multiply DEMO_COST_MULTIPLIER=3.0` (3x costs)
- Small offset: `DEMO_COST_STRATEGY=add DEMO_COST_ADDITION=500.0` (+$500)
- Slight reduction: `DEMO_COST_STRATEGY=reduce DEMO_COST_MULTIPLIER=0.9` (10% less)

### Compartment Naming (anonymize_compartment function)

Current format: `compartment-abc12345`

```python
def anonymize_compartment(name, ocid=None):
    suffix = get_ocid_suffix(ocid if ocid else name)
    return f"compartment-{suffix}"
```

Change to:
```python
def anonymize_compartment(name, ocid=None):
    suffix = get_ocid_suffix(ocid if ocid else name)
    return f"dept-{suffix}"  # dept-abc12345
```

### Resource Naming (anonymize_resource_name function)

Current format: `instance-abc12345`, `volume-xyz67890`, etc.

```python
def anonymize_resource_name(name, resource_type="resource", ocid=None):
    # ... type detection ...
    suffix = get_ocid_suffix(ocid if ocid else name)
    return f"{rtype}-{suffix}"
```

Change prefix:
```python
return f"server-{suffix}"  # For instances: server-abc12345
return f"disk-{suffix}"    # For volumes: disk-abc12345
```

---

## Troubleshooting

### Issue: Still Seeing Real Names

**Check:**
1. Is `DEMO_MODE=true` environment variable set?
2. Did you restart the backend after setting it?
3. Check terminal - do you see "🎭 DEMO MODE ACTIVE"?
4. Hard refresh frontend (Cmd+Shift+R)
5. **Clear chat history** - Old messages have cached real names

### Issue: AI Chat Shows Real Names

**Fixed!** AI tools now anonymize data before formatting responses. The format (`instance-abc12345`, `volume-xyz67890`) is consistent everywhere.

If you still see real names in AI chat:
1. **Clear chat history** - Old messages have cached real names
2. **Start new conversation** - Click "New Chat"
3. Verify demo mode is active in terminal logs

### Issue: Some Data Not Anonymized

Check the `anonymize_value()` function in `demo_middleware.py`. You may need to add more keywords to detect certain fields.

For example, to anonymize a field called `bucket_name`:
```python
elif any(keyword in key.lower() for keyword in [
    "display_name", "resource_name", "name", "instance_name", 
    "volume_name", "lb_name", "server_name", "bucket_name"  # Add this
]):
```

---

## Production Deployment Notes

### For Presentations:

1. **Before Demo:**
   ```bash
   export DEMO_MODE=true
   # Restart backend
   ```

2. **After Demo:**
   ```bash
   unset DEMO_MODE
   # Restart backend
   ```

### Security:

- Never commit with `DEMO_MODE=true` in code or `.env`
- Use environment variables (not hardcoded)
- Log clearly when demo mode is active
- Add a visible banner in frontend if desired (optional)

---

## Summary

### What You Get:

✅ **Simple** - One file, one environment variable  
✅ **Complete** - Works everywhere (dashboard, costs, chat, everything)  
✅ **Easy** - Enable/disable in 1 command  
✅ **Reversible** - Delete 1 file + remove 3 lines  
✅ **Effective** - All sensitive data anonymized  

### How to Use:

```bash
# Enable
export DEMO_MODE=true
uv run uvicorn app.main:app --reload

# Present with confidence!
# No real names, no real costs, AI chat works

# Disable
unset DEMO_MODE
uv run uvicorn app.main:app --reload
```

### How to Rollback:

```bash
# Step 1: Delete middleware file
rm backend/app/demo_middleware.py

# Step 2: Edit backend/app/main.py
# Remove import line and middleware registration (lines ~19 and ~70-75)

# Step 3: Edit backend/app/cloud/oci/ai_cache_tools.py
# Remove DEMO_MODE import, anonymize_for_demo() function
# Remove 5 anonymization calls in the AI tools

# Step 4: Restart backend
uv run uvicorn app.main:app --reload
```

**Done!** You now have a simple, effective, and easy-to-rollback demo mode. 🎉

**Summary of Files to Rollback:**
- ❌ Delete: `backend/app/demo_middleware.py`
- ✏️ Edit: `backend/app/main.py` (remove 2 sections)
- ✏️ Edit: `backend/app/cloud/oci/ai_cache_tools.py` (remove demo mode support)

