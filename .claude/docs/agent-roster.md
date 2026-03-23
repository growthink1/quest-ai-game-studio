# Agent Roster — Quest AI Learning Game

Agents are organized into four tiers. Quest adds a Pedagogy tier alongside the standard
game development hierarchy. The Pedagogy Director has co-equal authority with the
Creative Director — learning science and game design are peers, not subordinates.

## Tier 1 — Leadership Agents (Opus)
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `creative-director` | Creative vision | Game vision, pillars, tone, narrative/mechanic conflicts |
| `technical-director` | Technical vision | Architecture decisions, stack choices, performance strategy |
| `pedagogy-director` | Learning science | Bloom's alignment, CLT, ZPD, assessment validity, age-band decisions |
| `producer` | Production | Sprint planning, milestone tracking, risk, cross-team coordination |

## Tier 2 — Department Lead Agents (Sonnet)
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `game-designer` | Game mechanics | Core loops, progression, economy, balancing — with MDA + Bloom's hybrid |
| `curriculum-designer` | Competency graph | AI/ML skill nodes, prerequisite edges, learning paths, Neo4j Cypher |
| `lead-programmer` | Code architecture | System design, code review, API design, refactoring |
| `narrative-director` | Story and writing | Quest lore, character design, dialogue strategy, ludonarrative consonance |
| `qa-lead` | Quality assurance | Test strategy, bug triage, release readiness, regression planning |
| `release-manager` | Release pipeline | Build management, versioning, changelogs, deployment |
| `analytics-engineer` | Telemetry | Learning telemetry, BKT parameter estimation, engagement metrics |

## Tier 3 — Specialist Agents (Sonnet)

### Pedagogy Specialists
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `ai-sme` | AI/ML content accuracy | Validate technical accuracy, analogy quality, misconception risk |
| `assessment-designer` | Assessment design | Formative/summative assessments, distractor analysis, mastery gates |

### Engineering Specialists
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `adaptive-learning-engineer` | Student model + policy | BKT implementation, IRT calibration, policy-service, DAS |
| `gameplay-programmer` | Gameplay code | Unity C# gameplay systems, LearningLoop integration |
| `unity-specialist` | Unity 6 | MonoBehaviour/DOTS, Addressables, URP, Unity optimization |
| `unity-ui-specialist` | Unity UI | UI Toolkit, UXML/USS, age-tiered HUD, data binding |
| `engine-programmer` | Backend engine | FastAPI service internals, async patterns, DB optimization |
| `tools-programmer` | Dev tools | Editor extensions, pipeline tools, debug utilities |
| `ui-programmer` | Dashboard UI | Next.js parent dashboard, React components, data binding |
| `devops-engineer` | Build/deploy | Docker Compose, CI/CD, Railway deployment, GCP/Terraform |
| `security-engineer` | Security | COPPA compliance, moderation-service, data privacy, API security |

### Design Specialists
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `learning-module-designer` | Learning module design | Temporal pacing within a skill module, knowledge check placement, narrative arc |
| `systems-designer` | Systems design | Skill trees, XP curves, reward loops, progression formulas |
| `economy-designer` | Economy/balance | Resource economies, reward systems, pacing curves |
| `ux-designer` | UX flows | Age-tiered UX, accessibility, input handling, user flows |
| `prototyper` | Rapid prototyping | Throwaway mechanic prototypes, feasibility validation |
| `writer` | Narrative content | Quest dialogue, lore entries, feedback text, UI copy |
| `world-builder` | World/lore | Quest world rules, AI civilization lore, faction design |

### QA & Operations
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `qa-tester` | Test execution | Test cases, bug reports, learning assessment validation |
| `performance-analyst` | Performance | Profiling, adaptive engine latency, memory analysis |
| `accessibility-specialist` | Accessibility | WCAG, age-band UI rules, colorblind modes, text scaling |

## Engine Specialist Notes

Quest uses **Unity 6** for the game client. The following agents are active:
- `unity-specialist` — Unity 6 lead
- `unity-ui-specialist` — age-tiered HUD and quest UI

The following engine agents from the original Claude Code Game Studios template are
**not applicable to Quest** and have been deprecated:
- `godot-specialist` and sub-specialists (godot-gdscript, godot-shader, godot-gdextension)
- `unreal-specialist` and sub-specialists (ue-gas, ue-blueprint, ue-replication, ue-umg)
- `network-programmer` (replaced by security-engineer + devops-engineer for Quest's server-authoritative architecture)

## Coordination Map

```
[Hugo]
  ├── creative-director     ←→  pedagogy-director (co-equal authority)
  ├── technical-director
  └── producer
        │
        ├── game-designer ──────────→ systems-designer, learning-module-designer, economy-designer
        ├── curriculum-designer ────→ ai-sme, assessment-designer
        ├── lead-programmer ────────→ adaptive-learning-engineer, gameplay-programmer, unity-specialist
        ├── narrative-director ─────→ writer, world-builder
        ├── qa-lead ────────────────→ qa-tester, accessibility-specialist
        └── analytics-engineer
```

## Key Delegation Patterns for Quest

**New learning concept → competency graph:**
`pedagogy-director` → `curriculum-designer` → Cypher in `design/competency-graph/`

**New game mechanic that teaches AI:**
`creative-director` + `pedagogy-director` (joint) → `game-designer` → `systems-designer`

**Content accuracy gate:**
Any content → `ai-sme` review → `assessment-designer` (if assessment) → `pedagogy-director` approval

**Adaptive engine change:**
`pedagogy-director` (spec) → `adaptive-learning-engineer` (implementation) → `qa-tester` + `analytics-engineer`
