# Quest AI Learning Game — Claude Code Master Build Prompt

## Context: Who You Are and What Exists

You are operating inside the **Quest AI Game Studio** — a multi-agent Claude Code environment
with a specialized agent hierarchy designed for an educational game that teaches AI/ML concepts
to children through game mechanics.

**Your working repos:**
- `~/quest-ai-game-studio` — agent coordination, design docs, competency graph (this repo)
- `~/ai-learning-game` — backend platform (BKT contracts, FastAPI services, Unity scaffold)

**Read before doing anything else:**
1. `CLAUDE.md` — full stack, pedagogy framework, agent coordination rules
2. `UPSTREAM.md` — ai-learning-game platform integration reference
3. `.claude/docs/technical-preferences.md` — naming conventions, performance budgets, forbidden patterns
4. `.claude/docs/agent-roster.md` — full agent hierarchy
5. `design/competency-graph/index.md` — 24 skill nodes, 29 prerequisite edges already defined
6. `design/modules/ai.foundations.what-is-ai/module-design.md` — first complete module spec

---

## The Mission

Build Quest from its current design-complete state to a **fully launchable, playable educational
game** that teaches children AI/ML concepts. The game must be shippable — runnable locally with
`docker compose up`, playable in Unity, backend services live, content for the first learning
path complete.

**Definition of Done:**
- [ ] Backend: All 7 FastAPI services running, tested, integrated with Neo4j competency graph
- [ ] Student model: BKT mastery tracking live and returning correct posteriors
- [ ] Policy engine: Adaptive difficulty adjusting based on engagement/frustration/mastery signals
- [ ] Content: First 5 modules designed, content items authored, assessment items written
- [ ] Unity client: Playable game — ARIA narrative, 3 interaction types minimum (drag-sort, MC, sequence)
- [ ] Parent dashboard: Session summary, skill progress, mastery percentage
- [ ] Safety: Moderation service active, age-band UI rules enforced
- [ ] Infrastructure: docker-compose.yml runs clean with health checks passing
- [ ] Neo4j: Competency graph loaded (skills.cypher + relationships.cypher executed)

---

## Agent Delegation Map

Use the correct agent for each domain. **Always invoke agents by name using the agent system.**

### Tier 1 — Directors (invoke for architectural decisions)
- `pedagogy-director` → any Bloom's level dispute, age-band ruling, assessment validity question
- `creative-director` → narrative/pillar decisions, tone, ARIA character voice
- `technical-director` → architecture choices, service boundaries, database schema
- `producer` → sprint sequencing, dependency ordering, scope decisions

### Tier 2 — Department Leads (invoke for domain design)
- `curriculum-designer` → competency graph updates, learning path sequencing, Neo4j Cypher
- `game-designer` → mechanic design using Quest 9-section GDD standard (MDA + Bloom's hybrid)
- `lead-programmer` → API design, service interfaces, code architecture review
- `analytics-engineer` → BKT telemetry pipeline, engagement metrics schema

### Tier 3 — Specialists (invoke for implementation)
- `adaptive-learning-engineer` → student-model-service (BKT), policy-service (DAS)
- `assessment-designer` → content items, distractor design, mastery gate specs
- `ai-sme` → validate all AI/ML content for accuracy before shipping
- `learning-module-designer` → module arc design, hint scaffolding, difficulty curves
- `gameplay-programmer` → Unity C# LearningLoop, Telemetry, UI systems
- `unity-specialist` → Unity 6 architecture, Addressables, URP
- `engine-programmer` → FastAPI service implementation
- `devops-engineer` → Docker Compose, health checks, CI pipeline
- `security-engineer` → COPPA compliance, moderation-service, API auth
- `qa-tester` → test cases, contract validation, integration tests

---

## Build Order (Follow This Sequence)

### PHASE 1: Backend Foundation

**Goal:** All services running, health checks passing, contracts validated.

#### 1.1 — Implement student-model-service (invoke: adaptive-learning-engineer)
Build `services/student-model-service/` as a FastAPI service.

Required endpoints:
- `POST /interactions` — Body: LearningInteractionEvent; Returns: updated mastery state {skill_id, mastery_posterior, recommendation}; Internally: runs BKT update, persists to PostgreSQL
- `GET /learners/{learner_id}/mastery` — Returns: full mastery profile dict[skill_id, mastery_posterior]
- `GET /learners/{learner_id}/mastery/{skill_id}` — Returns: single skill mastery + BKT parameters

BKT update formula (implement exactly):
```python
def bkt_update(mastery_prior, response_correct, p_learn=0.30, p_guess=0.25, p_slip=0.08):
    p_correct_given_learned = 1 - p_slip if response_correct else p_slip
    p_correct_given_unlearned = p_guess if response_correct else 1 - p_guess
    numerator = mastery_prior * p_correct_given_learned
    denominator = numerator + (1 - mastery_prior) * p_correct_given_unlearned
    p_learned_given_response = numerator / denominator
    return min(p_learned_given_response + (1 - p_learned_given_response) * p_learn, 0.9999)
```

PostgreSQL schema:
```sql
CREATE TABLE learner_mastery (
    learner_id VARCHAR NOT NULL,
    skill_id VARCHAR NOT NULL,
    mastery_posterior FLOAT DEFAULT 0.15,
    interaction_count INT DEFAULT 0,
    last_seen TIMESTAMP,
    p_learn FLOAT DEFAULT 0.30,
    p_guess FLOAT DEFAULT 0.25,
    p_slip FLOAT DEFAULT 0.08,
    PRIMARY KEY (learner_id, skill_id)
);

CREATE TABLE interaction_log (
    id SERIAL PRIMARY KEY,
    learner_id VARCHAR NOT NULL,
    skill_id VARCHAR NOT NULL,
    session_id VARCHAR NOT NULL,
    difficulty_level FLOAT,
    response_correct BOOLEAN,
    mastery_prior FLOAT,
    mastery_posterior FLOAT,
    engagement_score FLOAT,
    frustration_proxy FLOAT,
    fatigue_proxy FLOAT,
    hint_count INT,
    response_latency_ms INT,
    age_band VARCHAR,
    created_at TIMESTAMP DEFAULT NOW()
);
```

Performance requirement: BKT update < 50ms. All endpoints async (FastAPI + asyncpg).

#### 1.2 — Implement policy-service (invoke: adaptive-learning-engineer)
Build `services/policy-service/` as a FastAPI service.

Required endpoints:
- `POST /decide` — Body: StateVector; Returns: LearningPolicyDecisionEvent
- `GET /actions` — Returns: full action registry with descriptions

StateVector:
```python
class StateVector(BaseModel):
    learner_id: str
    skill_id: str
    mastery_posterior: float
    difficulty_level: float
    engagement_score: float
    frustration_proxy: float
    fatigue_proxy: float
    hint_count_recent: int
    consecutive_correct: int
    consecutive_incorrect: int
    time_since_skill_last_seen: int  # seconds
    age_band: AgeBand
```

Policy action registry:
```python
class PolicyAction(StrEnum):
    RAISE_DIFFICULTY_SMALL = "raise_difficulty_small"    # +0.10
    RAISE_DIFFICULTY_LARGE = "raise_difficulty_large"    # +0.20
    LOWER_DIFFICULTY_SMALL = "lower_difficulty_small"    # -0.10
    LOWER_DIFFICULTY_LARGE = "lower_difficulty_large"    # -0.20
    ADD_HINT = "add_hint"
    REMOVE_HINT = "remove_hint"
    SWITCH_SKILL = "switch_skill"
    SCHEDULE_REVIEW = "schedule_review"
    OFFER_BREAK = "offer_break"
    UNLOCK_CONTENT = "unlock_content"
    MAINTAIN = "maintain"
```

Hard policy constraints (non-negotiable — enforce before any ML policy):
- frustration_proxy > 0.70 for 3+ consecutive interactions → LOWER_DIFFICULTY_LARGE
- fatigue_proxy > 0.80 → OFFER_BREAK
- mastery_posterior >= skill.mastery_threshold → UNLOCK_CONTENT
- consecutive_correct >= 3 → RAISE_DIFFICULTY_SMALL
- consecutive_incorrect >= 3 → LOWER_DIFFICULTY_SMALL + ADD_HINT

Performance requirement: policy decision < 200ms end-to-end.

#### 1.3 — Implement content-service (invoke: engine-programmer)
Build `services/content-service/` that stores/retrieves content items and queries Neo4j for
prerequisite checks.

Required endpoints:
- `POST /content/next` — Body: {learner_id, skill_id, mastery_posterior, difficulty_target}; Returns: ContentItem at difficulty_target ± 0.10
- `GET /content/skill/{skill_id}` — Returns: all content items sorted by difficulty
- `POST /content/items` — Admin endpoint to seed content
- `GET /prerequisites/{skill_id}` — Queries Neo4j for hard prerequisites; returns list of skill_ids with mastery status

ContentItem schema:
```python
class ContentItem(BaseModel):
    item_id: str
    skill_id: str
    bloom_level: str
    difficulty_level: float         # [0.0, 1.0] IRT calibrated
    age_band: AgeBand
    interaction_type: str           # "multiple_choice" | "drag_sort" | "sequence" | "construction"
    prompt: str
    options: list[dict]             # [{text, correct, misconception_key}]
    correct_feedback: str
    incorrect_feedback: str
    hint_1: str
    hint_2: str
    hint_3: str
    narrative_context: str          # ARIA dialogue for this item
    validated_by_ai_sme: bool = False
```

Neo4j integration: content-service must check prerequisite mastery before allowing skill access.
If prerequisite not mastered (mastery_posterior < mastery_threshold), return 403 with
{error: "prerequisite_not_met", required_skill: skill_id, current_mastery: float}.

#### 1.4 — Wire Neo4j competency graph (invoke: devops-engineer, curriculum-designer)
Add to docker-compose.yml:
```yaml
neo4j:
  image: neo4j:5
  environment:
    NEO4J_AUTH: neo4j/questpassword
    NEO4J_PLUGINS: '["apoc"]'
  ports:
    - "7474:7474"
    - "7687:7687"
  volumes:
    - neo4j_data:/data
  healthcheck:
    test: ["CMD-SHELL", "cypher-shell -u neo4j -p questpassword 'RETURN 1'"]
    interval: 10s
    timeout: 5s
    retries: 10
```

Create `scripts/seed-graph.sh`:
- Health-check neo4j (retry 10x with 3s sleep)
- Run `design/competency-graph/skills.cypher` — 24 skill nodes
- Run `design/competency-graph/relationships.cypher` — 29 prerequisite edges
- Verify: `MATCH (s:Skill) RETURN count(s)` should return 24

Add `seed-graph` target to Makefile that runs this script.

#### 1.5 — Update API gateway (invoke: lead-programmer, security-engineer)
Update `services/api-gateway/` routing:
- `POST /api/interactions` → student-model-service + policy-service in sequence
- `POST /api/content/next` → content-service (with prerequisite check)
- `GET /api/mastery/{learner_id}` → student-model-service
- `POST /api/sessions` → session-orchestrator

Add middleware:
- JWT auth: learner_id extracted from token claim
- Age-band header enforcement: X-Age-Band must match AgeBand enum
- Rate limiting: 60 req/min per learner_id

#### 1.6 — Integration test suite (invoke: qa-tester)
Write `tests/integration/test_full_pipeline.py`:
- Test: complete round-trip — POST interaction → assert mastery update → assert policy action
- Test: BKT correctness — known inputs (10 correct answers from mastery 0.15) → expected posterior ~0.80
- Test: policy constraints — frustration gate, fatigue gate, mastery unlock
- Test: prerequisite gate — attempt to access skill without mastered prerequisite → 403
- Test: contract compliance — all events validate against Pydantic models

---

### PHASE 2: Content — First Learning Path

**Goal:** 5 fully playable modules with validated content items for the AI Frontier early_elem path.

Learning Path: The AI Frontier (early_elem):
1. `ai.foundations.what-is-ai` → ARIA sorts mail (DESIGNED — module-design.md exists)
2. `ai.foundations.data` → ARIA's training archive
3. `ai.foundations.patterns` → ARIA finds patterns in mail
4. `ai.supervised.classification.level1` → The Sorting Gate
5. `ai.generative.llm.basics` → ARIA Learns to Write (age-adapted)

#### 2.1 — Seed Module 1 content items (invoke: assessment-designer, ai-sme)
Using `design/modules/ai.foundations.what-is-ai/module-design.md`, create ContentItem JSON for
all 10 interactions in `design/content/items/ai.foundations.what-is-ai/`.

Every item requires ai-sme validation before `validated_by_ai_sme: true` is set.

Required misconception coverage:
- "AI is magic" — narrative frame + interaction 5
- "AI = robots" — interaction 10 distractor D
- "AI follows rules" — interaction 7 rulebook option (distractor)
- "AI is always right" — interaction 5 scenario B answer

#### 2.2 — Design Modules 2-5 (invoke: learning-module-designer, ai-sme, assessment-designer)

For each module: produce module-design.md + seed content items + ai-sme validation + /learning-audit.

**Module 2: ai.foundations.data — "ARIA's Training Archive"**
- Narrative: ARIA shows the learner her archive of training examples
- Key concepts: features vs labels, why more examples help, labeled data
- Bloom's: Understand. Age band: early_elem
- 10 interactions, difficulty 0.15 → 0.65
- Interaction types: drag-sort (features vs labels), slider (data quantity), sequence

**Module 3: ai.foundations.patterns — "The Pattern Room"**
- Narrative: ARIA's pattern-recognition room where rules emerge from examples
- Key concepts: patterns in data, generalization vs memorization
- Bloom's: Apply. Age band: early_elem
- 10 interactions, difficulty 0.20 → 0.70
- Interaction types: pattern completion, spot-the-odd-one-out, analogy matching

**Module 4: ai.supervised.classification.level1 — "The Sorting Gate"**
- Narrative: ARIA's sorting gate categorizes mail into two groups
- Key concepts: binary classification, spam filter analogy, training examples
- Bloom's: Understand. Age band: upper_elem (accessible to advanced early_elem)
- 10 interactions, difficulty 0.30 → 0.75
- Interaction types: training simulation (learner "trains" ARIA), test evaluation

**Module 5: ai.generative.llm.basics — "ARIA Learns to Write" (age-adapted)**
- Narrative: New AI Guardian LYRA writes poems by predicting the next word
- Key concepts: next-word prediction, patterns in text, training on text data
- Bloom's: Understand. Age band: upper_elem
- CRITICAL: ai-sme must validate — must NOT imply LLMs "understand" or "think"
- Misconception guard: "LYRA knows what the words mean" — she predicts, she doesn't understand
- 10 interactions, difficulty 0.35 → 0.75

---

### PHASE 3: Unity Game Client

**Goal:** Playable Unity 6 game with ARIA narrative and 3 core interaction types.

#### 3.1 — Core game loop (invoke: gameplay-programmer)
Implement `Assets/Scripts/LearningLoop/LearningLoopController.cs`:

Responsibilities:
1. Start session: POST /api/sessions → get session_id
2. Request content: POST /api/content/next → ContentItem
3. Present interaction (delegates to InteractionView based on interaction_type)
4. Collect response: build LearningInteractionPayload with timing, hint_count
5. Submit: POST /api/interactions → get mastery update + policy action
6. Apply policy: adjust difficulty_target, show/hide hint, trigger ARIA reaction
7. Check mastery gate: if UNLOCK_CONTENT action → show celebration + advance
8. Loop: back to step 2

All API calls use generated contracts from packages/telemetry-sdk/generated/.
No hardcoded values. No direct DB access. Server-authoritative on age-band rules.

#### 3.2 — Three core interaction types (invoke: gameplay-programmer, unity-ui-specialist)

**DragSortInteraction** (`Assets/Scripts/UI/Interactions/DragSortInteraction.cs`):
- Two labeled drop zones (ARIA labels them from ContentItem.options metadata)
- Draggable item cards: icon + label, minimum 80px touch target
- Snap animation on correct drop, shake on incorrect
- Supports 2-6 items per interaction

**MultipleChoiceInteraction** (`Assets/Scripts/UI/Interactions/MultipleChoiceInteraction.cs`):
- 2-4 options as large tap buttons
- ARIA portrait shows reaction state after selection
- Hint button appears after 1 incorrect (shows hint_1 from ContentItem)
- Hint 2 after 2 incorrect (hint_2 text)
- Response latency tracked from interaction display to button tap

**SequenceOrderInteraction** (`Assets/Scripts/UI/Interactions/SequenceOrderInteraction.cs`):
- Orderable cards dragged into numbered slots (1, 2, 3...)
- "Check" button triggers validation
- Reveals correct sequence with animation on incorrect submit
- Re-orderable until correct or 3 attempts

All interaction types must:
- Fire `InteractionCompleted` event with response data for TelemetryManager
- Support both mouse and touch input
- Respect age-band touch target minimums (injected from session age_band)

#### 3.3 — ARIA character system (invoke: gameplay-programmer)
Implement `Assets/Scripts/ARIA/ARIAController.cs`:
- States: idle, speaking, happy, thinking, concerned, celebrating, encouraging
- Dialogue system reads ContentItem.narrative_context
- Text bubble display with age-band appropriate font size
- ARIAVoice.Speak(string) — logs to console + shows bubble (TTS placeholder)
- State transitions: happiness on correct, thinking on hint request, celebrating on module complete

ARIA visual brief (for art direction — placeholder sprites acceptable for v1):
- Friendly robot aesthetic, NOT humanoid
- Expressive eyes as primary emotion communicator
- Blue/teal color palette
- Round shapes, no sharp edges, works at 64px thumbnail and full screen

#### 3.4 — AI Frontier world map (invoke: unity-ui-specialist, gameplay-programmer)
Implement `Assets/Scripts/UI/WorldMap/WorldMapController.cs`:
- Loads competency graph topology from `GET /api/graph/skills` (add this to content-service)
- Renders skill nodes as map locations with prerequisite connections
- Node states: locked (grey), unlocked (blue pulse), in-progress (progress ring), mastered (gold)
- Progress ring = mastery_posterior as percentage
- Tapping a node: if unlocked → start that skill's module; if locked → show prerequisite tooltip
- Loads mastery data from `GET /api/mastery/{learner_id}` on map open

#### 3.5 — Telemetry (invoke: gameplay-programmer)
Implement `Assets/Scripts/Telemetry/TelemetryManager.cs`:
- Constructs LearningInteractionEvent after each interaction
- Calculates response_latency_ms from interaction display time to submission
- Rolling engagement_score: 5-interaction average of (1 - normalized_latency) + (1 - normalized_hint_count)
- Rolling frustration_proxy: 3-interaction average of (incorrect ? 1 : 0) + hint_count * 0.2, capped at 1.0
- Fatigue_proxy: session_duration_minutes / 20.0, capped at 1.0
- Submits via coroutine to avoid blocking main thread

---

### PHASE 4: Parent Dashboard

**Goal:** Next.js 14 dashboard showing child's learning progress.

Build `apps/parent-dashboard/` with three pages:

**`/dashboard`** — Today's session summary:
- Skills practiced today, interactions completed, mastery gains
- Current skill in learning path with progress to next unlock
- Streak counter

**`/progress`** — Full competency map:
- Visual competency map matching game's world map topology
- Mastery percentage per skill (from GET /api/mastery/{learner_id})
- Recent interactions: correct/incorrect breakdown by skill
- "Next unlock at X%" progress bars

**`/settings`** — Parental controls:
- Age band selector: toddler / early_elem / upper_elem / hs
- Session length limit: 10 / 20 / 30 minutes
- Notification preferences

Use generated TypeScript contracts from packages/telemetry-sdk/generated/.
All API calls through api-gateway. No direct service calls from dashboard.

---

### PHASE 5: Safety, Polish, Launch Readiness

#### 5.1 — Moderation service (invoke: security-engineer)
Implement `services/moderation-service/`:
- Content filter for any free-text (future-proofing)
- Age-band enforcement middleware in api-gateway
- Parent notification hooks (log to DB for now)
- COPPA compliance document at `docs/COPPA-COMPLIANCE.md`

#### 5.2 — Full test suite (invoke: qa-tester)
- `tests/integration/test_bkt_pipeline.py` — BKT correctness with known inputs
- `tests/integration/test_policy_constraints.py` — all hard policy gates
- `tests/integration/test_content_delivery.py` — difficulty targeting
- `tests/integration/test_mastery_gate.py` — skill unlock at threshold
- `tests/integration/test_contract_compliance.py` — Pydantic validation
- `tests/unity/PlayModeTests/` — Unity play mode for each interaction type

#### 5.3 — Production-ready Docker Compose (invoke: devops-engineer)
- Health checks on ALL services
- Dependency ordering: neo4j + postgres healthy before services start
- `scripts/seed-graph.sh` runs in initialization
- `.env.example` with all required variables documented
- `make up` → full stack live + seeded in < 60 seconds
- `make test` → full integration suite

#### 5.4 — Launch checklist (invoke: release-manager)
Run `/launch-checklist`. All required PASS items:
- All 7 services return 200 on /health
- BKT pipeline processes 100 interactions without errors
- All policy constraints tested and passing
- Module 1 complete — 10 items, ai-sme validated, /learning-audit PASS
- Unity: Module 1 end-to-end playable
- Parent dashboard: live mastery data displaying
- No hardcoded values in any service
- docker-compose up in < 60 seconds

---

## What NOT to Do

- Never hardcode difficulty values, learner IDs, skill IDs — always from contracts/config
- Never skip ai-sme validation on any content item
- Never modify Pydantic contracts without regenerating telemetry-sdk artifacts
- Never implement age-band logic in Unity client — server-authoritative
- Never use free-text input for early_elem learners
- Never let frustration_proxy > 0.70 for 3+ interactions without policy response
- Never deploy without COPPA compliance checklist complete

---

## Architecture Decisions Already Made — Do Not Re-litigate

- ADR-001: Unity 6 for game client
- ADR-002: Neo4j for competency graph
- ADR-003: BKT for mastery tracking (interpretable for parents)
- ADR-004: COPPA compliance via server-side moderation
- ADR-005: Pydantic contracts as source of truth — C# and TypeScript generated, never manually maintained

All in `.claude/docs/technical-preferences.md`.

---

## Session Start Command for Claude Code

Paste this to begin:

```
Read QUEST_BUILD_PROMPT.md, CLAUDE.md, UPSTREAM.md, and .claude/docs/technical-preferences.md.

We are building Quest from design-complete to fully playable. Begin Phase 1.

Use the producer agent to review Phase 1 scope and confirm build order, then invoke the
adaptive-learning-engineer agent to implement the student-model-service per the spec in
QUEST_BUILD_PROMPT.md section 1.1. Show me the proposed service architecture before writing
any code.

Coordination rules apply: Question → Options → Decision → Draft → Approval before writing files.
```
