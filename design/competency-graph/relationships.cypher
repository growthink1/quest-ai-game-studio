// Quest AI Learning Game — Competency Graph
// Prerequisite Relationships
// Last Updated: 2026-03-23
// strength: 'hard' = must be mastered; 'soft' = recommended

// ============================================================
// FOUNDATIONS CHAIN
// ============================================================

// Data is prerequisite to pattern recognition
MATCH (a:Skill {skill_id: 'ai.foundations.what-is-ai'}),
      (b:Skill {skill_id: 'ai.foundations.data'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.foundations.data'}),
      (b:Skill {skill_id: 'ai.foundations.patterns'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.foundations.patterns'}),
      (b:Skill {skill_id: 'ai.foundations.algorithms'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

MATCH (a:Skill {skill_id: 'ai.foundations.algorithms'}),
      (b:Skill {skill_id: 'ai.foundations.training'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// ============================================================
// SUPERVISED LEARNING CHAIN
// ============================================================

// Training concept unlocks classification and regression
MATCH (a:Skill {skill_id: 'ai.foundations.training'}),
      (b:Skill {skill_id: 'ai.supervised.classification.level1'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.foundations.training'}),
      (b:Skill {skill_id: 'ai.supervised.regression.level1'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Level 1 classification before level 2
MATCH (a:Skill {skill_id: 'ai.supervised.classification.level1'}),
      (b:Skill {skill_id: 'ai.supervised.classification.level2'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Both classification and regression before training concepts
MATCH (a:Skill {skill_id: 'ai.supervised.classification.level1'}),
      (b:Skill {skill_id: 'ai.supervised.training'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Training/test split before evaluation
MATCH (a:Skill {skill_id: 'ai.supervised.training'}),
      (b:Skill {skill_id: 'ai.supervised.evaluation'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// ============================================================
// ETHICS CHAIN
// ============================================================

// Data concepts before privacy
MATCH (a:Skill {skill_id: 'ai.foundations.data'}),
      (b:Skill {skill_id: 'ai.ethics.privacy'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// Classification before bias (need to understand what a model does before discussing its failures)
MATCH (a:Skill {skill_id: 'ai.supervised.classification.level1'}),
      (b:Skill {skill_id: 'ai.ethics.bias'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// Bias before fairness (fairness requires understanding bias)
MATCH (a:Skill {skill_id: 'ai.ethics.bias'}),
      (b:Skill {skill_id: 'ai.ethics.fairness'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Evaluation before fairness (fairness metrics require evaluation understanding)
MATCH (a:Skill {skill_id: 'ai.supervised.evaluation'}),
      (b:Skill {skill_id: 'ai.ethics.fairness'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// ============================================================
// GENERATIVE AI CHAIN
// ============================================================

// Foundations before LLM basics
MATCH (a:Skill {skill_id: 'ai.foundations.patterns'}),
      (b:Skill {skill_id: 'ai.generative.llm.basics'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// LLM basics before limitations and prompt engineering
MATCH (a:Skill {skill_id: 'ai.generative.llm.basics'}),
      (b:Skill {skill_id: 'ai.generative.llm.limitations'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.generative.llm.basics'}),
      (b:Skill {skill_id: 'ai.generative.prompt'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);
