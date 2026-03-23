# Upstream: ai-learning-game Platform

**Repo:** `growthink1/ai-learning-game` (private, branch: `master`)
**Role in Quest:** The backend platform that powers all adaptive learning functionality.
Quest's game client and agent coordination layer sit on top of this platform.

---

## Architecture Overview

```
quest-ai-game-studio (this repo)
  ├── Game design & agent coordination  ← You are here
  ├── Competency graph (Neo4j Cypher)
  ├── Module designs & content specs
  └── REFERENCES → ai-learning-game (backend platform)
                        ├── packages/contracts    ← Canonical event models
                        ├── services/*            ← FastAPI microservices
                        ├── apps/game-client      ← Unity 6 scaffold
                        └── infra/                ← GCP/Terraform
```

---

## Critical Files in ai-learning-game

### Event Contracts (`packages/contracts/src/contracts/models.py`)
These are the canonical data models. Every interaction in Quest produces events
conforming to these models. Never define ad-hoc schemas.

```python
# Key models:
LearningInteractionEvent   # Every learner action → BKT update
LearningPolicyDecisionEvent # Adaptive engine decision log
AgeBand                    # toddler | early_elem | upper_elem | hs
EventType                  # learning.interaction | learning.policy_decision | ...
```

**`LearningInteractionEvent` key fields:**
```python
skill_id: str               # Maps to skill_id in competency graph
difficulty_level: float     # [0.0, 1.0] — IRT difficulty
response_correct: bool      # BKT update input
mastery_prior: float        # BKT posterior from PREVIOUS interaction
mastery_posterior: float    # BKT posterior AFTER this interaction
engagement_score: float     # [0.0, 1.0]
frustration_proxy: float    # [0.0, 1.0] — policy gate at 0.7
fatigue_proxy: float        # [0.0, 1.0] — policy gate at 0.8
hint_count: int             # Number of hints used
response_latency_ms: int    # Time to respond
age_band: AgeBand           # Learner's age tier
```

### Microservices (all in `services/`)

| Service | Port | Responsibility |
|---|---|---|
| `api-gateway` | 8000 | Unified entry point, auth |
| `session-orchestrator` | 8001 | Session state, Redis |
| `policy-service` | 8002 | Adaptive difficulty, RL policy decisions |
| `student-model-service` | 8003 | BKT mastery tracking, PostgreSQL |
| `content-service` | 8004 | Content item delivery |
| `messaging-service` | 8005 | Parent/child social layer |
| `moderation-service` | 8006 | COPPA safety layer |

### Docker Compose
```bash
cd ai-learning-game
docker compose up -d --build
# Services start on ports 8000-8006
# PostgreSQL on 5432, Redis on 6379
```

### Unity Client Scaffold (`apps/game-client`)
```
Assets/Scripts/
  LearningLoop/    # Interaction dispatch → POST /api/interactions
  Telemetry/       # LearningInteractionEvent serialization
  UI/              # Age-tiered HUD (AgeBand-aware)
  Networking/      # Session gateway client
```

---

## Integration Pattern

Quest module designers and agent developers reference ai-learning-game for:

1. **Event contract compliance** — all content items and assessments must specify
   their `difficulty_level` and target `skill_id`. These populate `LearningInteractionEvent`.

2. **Policy action vocabulary** — adaptive policy actions (raise_difficulty, lower_difficulty,
   add_hint, offer_break, etc.) are defined in `services/policy-service/actions.py`.
   Module designs reference these by name.

3. **BKT parameter defaults** — P(L0), P(T), P(G), P(S) defaults come from the student-model-service.
   Module designs can specify custom values in their BKT Parameters section.

4. **Age band constraints** — `AgeBand` enum values and UI rules from `apps/game-client`
   inform all module design age-band constraints.

---

## Development Workflow

```bash
# Start platform locally
cd ~/ai-learning-game
docker compose up -d --build

# Verify services
curl http://localhost:8000/health
curl http://localhost:8003/health  # student-model-service

# Run platform tests
cd ~/ai-learning-game && make test

# After changes to contracts, regenerate SDK
node scripts/generate-typed-clients.mjs
```

---

## Quest-Specific Extensions (to build in ai-learning-game)

These features are planned but not yet implemented in the upstream platform:

| Feature | Target Service | Priority |
|---|---|---|
| Neo4j competency graph integration | `content-service` or new `graph-service` | High |
| Skill prerequisite gate enforcement | `session-orchestrator` | High |
| Spaced repetition scheduler | `policy-service` | Medium |
| Parent dashboard learning progress | `apps/parent-dashboard` | Medium |
| Age-band adaptive UI contracts | `apps/game-client` | High |

---

## Sync Protocol

When ai-learning-game contracts change:
1. Update `packages/contracts/src/contracts/models.py`
2. Run `node scripts/generate-typed-clients.mjs` to regenerate TypeScript/C# artifacts
3. Update this UPSTREAM.md if service ports or architecture changes
4. Notify `adaptive-learning-engineer` and `gameplay-programmer` agents
