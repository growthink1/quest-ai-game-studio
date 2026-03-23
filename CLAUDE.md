# Quest AI Game Studio — Agent Architecture

Quest is an AI-focused educational game that teaches AI/ML concepts through game mechanics.
Built on the adaptive-family-learning-game platform with Claude Code Game Studios agent coordination.

## Technology Stack

### Game Client
- **Engine**: Unity 6 (C#)
- **Client Repo**: `apps/game-client` — Unity integration, telemetry, adaptive response handling
- **Key Scripts**: `Assets/Scripts/LearningLoop`, `Assets/Scripts/Telemetry`, `Assets/Scripts/UI`

### Backend Services (FastAPI microservices)
- **api-gateway**: Port 8000 — unified entry point
- **session-orchestrator**: Port 8001 — session state, Redis-backed
- **policy-service**: Port 8002 — adaptive difficulty / RL policy engine
- **student-model-service**: Port 8003 — BKT/IRT mastery tracking
- **content-service**: Port 8004 — curriculum content delivery
- **messaging-service**: Port 8005 — parent/child/sibling social layer
- **moderation-service**: Port 8006 — COPPA-aware safety/moderation

### Data Layer
- **PostgreSQL**: Learner state, session history, mastery records
- **Redis**: Session state, real-time policy decisions
- **Neo4j**: Competency graph — skill nodes, prerequisite edges, mastery thresholds

### Shared Contracts
- **packages/contracts**: Pydantic event models — canonical source of truth
- **packages/telemetry-sdk**: TypeScript/C# generated artifacts for Unity client
- Key models: `LearningInteractionEvent`, `LearningPolicyDecisionEvent`, `AgeBand`, `EventType`

### Infrastructure
- **Docker Compose**: Local dev stack (`docker compose up -d --build`)
- **GCP/Terraform**: `infra/terraform-gcp` production blueprint
- **Version Control**: Git trunk-based development

## Pedagogy Framework

All learning design decisions are grounded in:
- **Bloom's Taxonomy**: Cognitive levels (Remember → Understand → Apply → Analyze → Evaluate → Create)
- **BKT (Bayesian Knowledge Tracing)**: `mastery_prior` / `mastery_posterior` per skill interaction
- **IRT (Item Response Theory)**: `difficulty_level` [0.0-1.0] calibrated per content item
- **Self-Determination Theory**: Autonomy, Competence, Relatedness in every system
- **Flow State Design**: `engagement_score`, `frustration_proxy`, `fatigue_proxy` tracked per interaction
- **Spaced Repetition**: Skill revisit scheduling in `policy-service`
- **Age Bands**: toddler / early_elem / upper_elem / hs — all content and UI tiered

## Competency Graph (Neo4j)

AI/ML concepts are modeled as a directed prerequisite graph:
- Nodes: skill_id (e.g., `ai.supervised.classification.level1`)
- Edges: prerequisite relationships
- Properties: mastery_threshold, bloom_level, age_band, difficulty_range
- Managed by: `curriculum-designer` agent → Cypher in `design/competency-graph/`

## Project Structure

@.claude/docs/directory-structure.md

## Technical Preferences

@.claude/docs/technical-preferences.md

## Coordination Rules

@.claude/docs/coordination-rules.md

## Collaboration Protocol

**User-driven collaboration, not autonomous execution.**
Every task follows: **Question -> Options -> Decision -> Draft -> Approval**

- Agents MUST ask "May I write this to [filepath]?" before using Write/Edit tools
- Agents MUST show drafts or summaries before requesting approval
- Multi-file changes require explicit approval for the full changeset
- No commits without user instruction
- All gameplay values must reference contract models in `packages/contracts`
- Assessment decisions must trace to a Bloom's taxonomy level

See `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` for full protocol and examples.

> **First session?** Run `/start` to begin guided onboarding.
> **Adding a new AI concept?** Run `/competency-map` to update the Neo4j skill graph.
> **Designing a learning module?** Run `/learning-audit` to validate Bloom's coverage.

## Coding Standards

@.claude/docs/coding-standards.md

## Context Management

@.claude/docs/context-management.md
