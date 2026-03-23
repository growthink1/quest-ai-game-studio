---
name: assessment-review
description: "Review an assessment item or set of items for construct validity, Bloom's alignment, distractor quality, and misconception coverage. Produces a structured review with PASS/FAIL verdict per item and overall coverage analysis."
argument-hint: "[path to assessment items file or skill_id, e.g. 'design/content/assessments/ai.supervised.classification.level1/']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion
---

When this skill is invoked:

## 1. Parse Arguments

If a path is provided, read the assessment item files at that path.
If a skill_id is provided, look for items at `design/content/assessments/{skill_id}/`.
If neither, ask the user which skill or file to review.

## 2. Gather Context

```
design/competency-graph/skills.cypher          (skill's bloom_level, difficulty range, age_band)
design/content/misconceptions/{skill_id}.md    (known misconceptions for this concept, if exists)
.claude/docs/technical-preferences.md          (age-band UI/language rules)
```

## 3. Review Each Item

For each assessment item, evaluate:

### Check 1: Construct Validity
Does this item measure the intended learning objective, or does it measure something else?
- Does answering correctly require the target cognitive skill?
- Could a learner answer correctly WITHOUT understanding the concept? (guessing risk)
- Could a learner who understands the concept answer incorrectly due to irrelevant factors?
  (construct-irrelevant variance — game skill, UI confusion, reading level)
- PASS: Item cleanly measures the target construct
- FAIL: Item measures game skill, reading ability, or luck more than learning

### Check 2: Bloom's Level Match
Does the cognitive demand of this item match the skill's stated Bloom's level?
- Remember: Can the learner recall a fact?
- Understand: Can the learner explain in their own words?
- Apply: Can the learner use the concept in a new situation?
- Analyze: Can the learner break down components or compare approaches?
- Evaluate: Can the learner judge quality or make a reasoned choice?
- Create: Can the learner produce something new using the concept?
- PASS: Item's cognitive demand matches stated level ±1 level
- FAIL: Item demands significantly lower or higher cognitive level than stated

### Check 3: Distractor Quality
Each distractor should represent a specific, diagnosable misconception.
- Is each distractor plausible to someone with the target misconception?
- Does each distractor map to a specific misconception in the misconception registry?
- Are distractors too obviously wrong? (low cognitive demand — just pick the non-silly answer)
- Are distractors too tricky? (requires knowledge ABOVE the skill's bloom_level)
- PASS: All distractors are plausible, misconception-mapped, and at appropriate level
- CONCERN: 1 distractor is weak (too obvious or unmapped)
- FAIL: Multiple distractors are weak or no misconception mapping exists

### Check 4: Difficulty Calibration
Does the item's difficulty_level match its actual cognitive demand?
- Compare stated difficulty to assessed cognitive demand
- For the target age band: is this achievable with mastery, but challenging without?
- PASS: Difficulty plausible given Bloom's level and age band
- CONCERN: Difficulty seems over- or under-stated by >0.20

### Check 5: Feedback Quality
- Is correct feedback confirmatory AND elaborative? (not just "correct!")
- Does incorrect feedback name the misconception AND provide the correction?
- Is the language appropriate for the target age band?
- PASS: Both correct and incorrect feedback are instructive
- FAIL: Feedback is minimal or doesn't address the misconception

## 4. Coverage Analysis

After reviewing individual items, analyze the set as a whole:

```
Bloom's coverage:
  Remember:    [N items] [ADEQUATE / MISSING]
  Understand:  [N items] [ADEQUATE / MISSING]
  Apply:       [N items] [ADEQUATE / MISSING]
  [higher levels if applicable]

Difficulty coverage:
  Range covered: [{min} - {max}]
  Target range: [{skill difficulty_min} - {skill difficulty_max}]
  Gaps: [difficulty ranges with no items]

Misconception coverage:
  Known misconceptions: [N]
  Covered by distractors: [N]
  Uncovered: [list any major misconceptions with no distractor]

Minimum items for mastery gate:
  Current: [N items]
  Required minimum: 5
  Status: [ADEQUATE / INSUFFICIENT]
```

## 5. Generate Review Report

Write to `design/audits/{skill_id}-assessment-review-{date}.md`:

```markdown
# Assessment Review: {skill_name} ({skill_id})
Date: {date}
Items reviewed: {N}

## Overall Verdict: PASS | CONDITIONAL PASS | FAIL

## Item-by-Item Results

### Item {item_id}
- Construct validity: PASS | FAIL — [finding]
- Bloom's alignment: PASS | FAIL — stated {level}, actual {level}
- Distractor quality: PASS | CONCERN | FAIL — [finding]
- Difficulty calibration: PASS | CONCERN — stated {X}, assessed {Y}
- Feedback quality: PASS | FAIL — [finding]
- **Item verdict: APPROVED | REVISE | REJECT**

[repeat for each item]

## Coverage Analysis
[paste coverage analysis block]

## Priority Actions
1. [Critical — required before assessment can be used]
2. [Important]
3. [Enhancement]

## Validated by: /assessment-review skill
## Requires human sign-off: pedagogy-director + ai-sme
```

## 6. Notify

- `assessment-designer`: share report, request revisions on REVISE/REJECT items
- `ai-sme`: flag any items with content accuracy concerns
- `pedagogy-director`: notify if overall verdict is FAIL
