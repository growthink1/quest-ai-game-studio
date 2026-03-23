---
name: learning-audit
description: "Audit a learning module, game mechanic, or piece of content against Bloom's taxonomy, CLT, SDT, and age-band appropriateness. Produces a structured audit report with pass/fail verdict and specific improvement recommendations."
argument-hint: "[path to module design doc or content file, e.g. 'design/modules/ai.supervised.classification.level1/module-design.md']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion
---

When this skill is invoked:

## 1. Parse Arguments

Read the target file — a module design doc, game mechanic spec, or content item.
If no argument provided, ask the user which document to audit.

## 2. Gather Context

Read relevant reference files:
```
.claude/docs/technical-preferences.md   (age-band rules, performance budgets)
design/competency-graph/skills.cypher   (target skill's bloom_level, age_band_min)
```

If auditing a module, also read:
```
design/modules/{skill_id}/module-design.md
```

## 3. Run the Audit

Evaluate against five dimensions:

### Dimension 1: Bloom's Taxonomy Alignment
- What cognitive level does this content/mechanic actually assess?
- Does it match the stated Bloom's level in the competency graph?
- Is the assessment item congruent with the learning objective?
- PASS: Stated level matches actual cognitive demand
- FAIL: Mismatch — e.g., stated "Apply" but only requires "Remember"

### Dimension 2: Cognitive Load Theory (CLT)
- Intrinsic load: Is the concept's inherent complexity appropriate for the age band?
- Extraneous load: Does the UI/instructions add unnecessary complexity?
- Germane load: Does the design promote schema formation (worked examples, elaboration)?
- PASS: Extraneous load minimized; intrinsic load managed via scaffolding
- CONCERN: Any unnecessary complexity that could be reduced
- FAIL: Extraneous load dominates; learner likely overwhelmed by presentation not concept

### Dimension 3: Self-Determination Theory (SDT)
- Autonomy: Does the learner have meaningful choice?
- Competence: Is there clear skill feedback? Is the challenge-skill balance in the flow channel?
- Relatedness: Is the concept connected to the learner's world?
- PASS: At least 2 of 3 SDT needs served
- CONCERN: Only 1 SDT need served
- FAIL: No SDT needs served

### Dimension 4: Age-Band Appropriateness
Check content against the target age_band_min from the skill definition:
- **toddler**: No abstractions. No free text. Audio-first. Concrete/observable only.
- **early_elem**: Analogy-based. Cause-and-effect. Simplified vocabulary.
- **upper_elem**: Rule-based. Conditional logic acceptable. Formal hints OK.
- **hs**: Formal notation acceptable. Trade-off analysis OK. Meta-cognitive prompts OK.
- PASS: Content matches age-band constraints
- FAIL: Content uses abstractions/vocabulary above target age band

### Dimension 5: ZPD / Difficulty Calibration
- Is the difficulty_level in the productive struggle zone [0.40-0.75]?
- Does difficulty follow the sawtooth pattern within the module?
- Are there frustration gates (>3 consecutive failures → reduce difficulty)?
- PASS: Difficulty profile in ZPD range with appropriate progression
- CONCERN: Difficulty outside range but recoverable
- FAIL: Difficulty profile likely to cause boredom (<0.30) or frustration (>0.80)

## 4. Generate Audit Report

Write the report to `design/audits/{skill_id}-learning-audit-{date}.md`:

```markdown
# Learning Audit: {skill_name}
Date: {date}
Audited by: /learning-audit skill

## Verdict: PASS | CONDITIONAL PASS | FAIL

## Summary
[2-3 sentence overview of findings]

## Dimension Results

### Bloom's Alignment: PASS | CONCERN | FAIL
- Stated level: {bloom_level}
- Actual cognitive demand: {assessed_level}
- Finding: [specific finding]
- Recommendation: [if CONCERN or FAIL]

### Cognitive Load: PASS | CONCERN | FAIL
- Intrinsic load assessment: [finding]
- Extraneous load: [finding]
- Germane load: [finding]
- Recommendation: [if CONCERN or FAIL]

### SDT Coverage: PASS | CONCERN | FAIL
- Autonomy: [served / not served — why]
- Competence: [served / not served — why]
- Relatedness: [served / not served — why]
- Recommendation: [if CONCERN or FAIL]

### Age-Band Appropriateness: PASS | CONCERN | FAIL
- Target age band: {age_band}
- Finding: [specific vocabulary/abstraction issues if any]
- Recommendation: [if CONCERN or FAIL]

### ZPD / Difficulty: PASS | CONCERN | FAIL
- Difficulty range: [{min} - {max}]
- ZPD target: [0.40 - 0.75]
- Finding: [specific difficulty profile issues if any]
- Recommendation: [if CONCERN or FAIL]

## Priority Fixes
1. [Most critical fix — required before ship]
2. [Second priority]
3. [Nice to have]

## Approved to Ship: YES | NO (pending fixes)
```

## 5. Notify

If verdict is FAIL or CONDITIONAL PASS:
- Notify `pedagogy-director` for review
- Notify `assessment-designer` if assessment items need revision
- Notify `ai-sme` if content accuracy is a concern
