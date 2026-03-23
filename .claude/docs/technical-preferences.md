# Technical Preferences

## Engine & Language

- **Engine**: Unity 6
- **Game Language**: C#
- **Backend Language**: Python 3.12 (FastAPI)
- **Dashboard Language**: TypeScript (Next.js)
- **Contract Language**: Python/Pydantic (source of truth) + generated TypeScript/C# artifacts

## Naming Conventions

- **C# Classes**: PascalCase (e.g., `LearningLoopController`)
- **C# Variables**: camelCase (e.g., `masteryScore`)
- **Python Classes**: PascalCase (e.g., `StudentModelService`)
- **Python Variables**: snake_case (e.g., `mastery_posterior`)
- **Event Types**: dot-notation strings (e.g., `learning.interaction`, `learning.policy_decision`)
- **Skill IDs**: dot-notation hierarchy (e.g., `ai.supervised.classification.level1`)
- **Files (Python)**: snake_case (e.g., `student_model_service.py`)
- **Files (C#)**: PascalCase (e.g., `LearningLoopController.cs`)

## Performance Budgets

- **Target Framerate**: 60fps (Unity client)
- **Frame Budget**: 16.67ms
- **Adaptive Engine Response**: < 200ms per policy decision
- **API Gateway p99**: < 500ms
- **Student Model Update**: < 100ms per interaction event

## Event Contract Standards

ALL telemetry and API payloads MUST use models from `packages/contracts/src/contracts/models.py`:
- Never define ad-hoc payload schemas — extend the canonical models
- C#/TypeScript consumers use generated artifacts from `packages/telemetry-sdk/generated`
- Every `LearningInteractionEvent` MUST include: `mastery_prior`, `mastery_posterior`, `difficulty_level`, `engagement_score`
- `policy_action` field must reference an action defined in `policy-service` action registry

## Mastery & Assessment Standards

- Mastery threshold per skill: configurable in Neo4j competency graph (default: 0.80)
- BKT update: every `LearningInteractionEvent` triggers a mastery_posterior recalculation
- Difficulty adjustment: bounded [0.05, 0.95] — never at extremes
- Frustration gate: if `frustration_proxy > 0.7` for 3 consecutive events → policy MUST reduce difficulty
- Fatigue gate: if `fatigue_proxy > 0.8` → policy MUST offer break or switch skill

## Age Band UI Rules

- **toddler**: No free text input. Large touch targets (min 80px). Audio-first.
- **early_elem**: Simplified vocabulary. Hint system always visible.
- **upper_elem**: Full UI. Competitive elements permitted.
- **hs**: Full UI. Meta-cognitive reflection prompts permitted.

## Testing

- **Python**: pytest, minimum 80% coverage on service logic
- **C#**: Unity Test Framework (Play Mode + Edit Mode)
- **Contracts**: JSON schema validation tests in `tests/test_contracts.py`
- **Integration**: Docker Compose stack (`make test`)
- **Required Tests**: All BKT update logic, policy decision boundaries, contract schema generation

## Forbidden Patterns

- Hardcoded difficulty values — use `difficulty_level` from content database
- Direct DB access from Unity client — all data via api-gateway
- Age-band logic in game client — server-authoritative via policy-service
- Skipping `mastery_prior` in interaction events — always required
- Free-text messages from children without moderation-service validation

## Allowed Libraries

### Python (Backend)
- FastAPI, Pydantic v2, pydantic-settings
- SQLAlchemy, asyncpg (PostgreSQL)
- redis-py (async)
- neo4j Python driver
- PyGithub (memory tools)

### TypeScript (Dashboard)
- Next.js 14, React, Tailwind CSS
- Zod (runtime validation)

### C# (Unity)
- Generated telemetry SDK artifacts from `packages/telemetry-sdk/generated`
- Newtonsoft.Json for serialization

## Architecture Decisions Log

- **ADR-001**: Unity 6 chosen for game client — 19 agent set available, C# contracts auto-generated
- **ADR-002**: Neo4j for competency graph — prerequisite relationships are native graph structure
- **ADR-003**: BKT over pure IRT for mastery tracking — interpretability for parent dashboard
- **ADR-004**: COPPA compliance via server-side moderation — no free-text from client without server validation
- **ADR-005**: Pydantic contracts as source of truth — C# and TypeScript are generated, never manually maintained
