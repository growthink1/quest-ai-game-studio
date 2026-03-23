---
name: competency-map
description: "Decompose an AI/ML concept into skill nodes, map prerequisite dependencies, generate Cypher for the Neo4j competency graph, and update the systems index."
argument-hint: "[skill domain or concept, e.g. 'supervised learning' or 'neural networks'] or 'next' to pick highest-priority unmapped concept"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion
---

When this skill is invoked:

## 1. Parse Arguments

Two modes:
- **No argument or domain name**: `/competency-map supervised-learning` — Map all skills in the given domain
- **`next`**: `/competency-map next` — Pick the highest-priority unmapped domain from the curriculum roadmap

## 2. Read Existing Graph State

```
Read: design/competency-graph/skills.cypher     (existing skill nodes)
Read: design/competency-graph/relationships.cypher (existing prerequisite edges)
Read: design/competency-graph/paths/             (existing learning paths)
Read: .claude/docs/technical-preferences.md     (age band rules, difficulty standards)
```

If files don't exist yet, initialize them with headers.

## 3. Identify Concepts to Map

For the given domain, enumerate all AI/ML concepts that Quest should teach.
Use the curriculum domain taxonomy from `curriculum-designer` agent as reference.

For each concept, determine:
- `skill_id` (dot-notation: `ai.domain.concept.level`)
- `bloom_level` (Remember → Create)
- `age_band_min` (earliest age band this concept is appropriate for)
- `difficulty_min` / `difficulty_max` (IRT difficulty range)
- `mastery_threshold` (default 0.80, higher for foundational skills)
- `estimated_interactions` (how many interactions to reach mastery)
- Prerequisites (which skills must be mastered first?)

## 4. Present Mapping for Review

Before writing any Cypher, show the user:
1. The proposed skill nodes (table format: skill_id, bloom_level, age_band, prereqs)
2. The prerequisite graph (text representation: A → B → C)
3. Any gaps or conflicts with existing graph

Use AskUserQuestion for:
- Bloom's level disputes ("Should 'gradient descent intuition' be Understand or Apply?")
- Age band minimums ("Is binary classification appropriate for early_elem?")
- Prerequisite ordering questions

## 5. Generate Cypher

After approval, generate:

**skills.cypher additions:**
```cypher
// [Domain Name] Skills — Added [date]
CREATE (s:Skill {
  skill_id: '...',
  name: '...',
  description: '...',
  bloom_level: '...',
  age_band_min: '...',
  difficulty_min: 0.XX,
  difficulty_max: 0.XX,
  mastery_threshold: 0.80,
  estimated_interactions: N
});
```

**relationships.cypher additions:**
```cypher
// [Domain Name] Prerequisites — Added [date]
MATCH (a:Skill {skill_id: 'prerequisite.skill'}),
      (b:Skill {skill_id: 'dependent.skill'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);
```

## 6. Update Systems Index

Update `design/competency-graph/index.md` with:
- Total skill count
- Domain coverage summary
- Unmapped domains still needed
- Date last updated

## 7. Notify Relevant Agents

After committing:
- Notify `curriculum-designer` to update learning paths
- Notify `assessment-designer` to create assessment items for new skills
- Notify `ai-sme` to validate concept accuracy in skill descriptions
