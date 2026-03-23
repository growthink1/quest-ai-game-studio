// Quest AI Learning Game — Competency Graph
// Prerequisite Relationships
// Last Updated: 2026-03-23
// strength: 'hard' = must be mastered; 'soft' = recommended

// ============================================================
// FOUNDATIONS CHAIN
// ============================================================

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

MATCH (a:Skill {skill_id: 'ai.foundations.training'}),
      (b:Skill {skill_id: 'ai.supervised.classification.level1'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.foundations.training'}),
      (b:Skill {skill_id: 'ai.supervised.regression.level1'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.supervised.classification.level1'}),
      (b:Skill {skill_id: 'ai.supervised.classification.level2'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.supervised.classification.level1'}),
      (b:Skill {skill_id: 'ai.supervised.training'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.supervised.training'}),
      (b:Skill {skill_id: 'ai.supervised.evaluation'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// ============================================================
// NEURAL NETWORKS CHAIN
// ============================================================

// Training concept unlocks perceptron (must understand learning before neurons)
MATCH (a:Skill {skill_id: 'ai.foundations.training'}),
      (b:Skill {skill_id: 'ai.neural.perceptron'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// Perceptron before layers
MATCH (a:Skill {skill_id: 'ai.neural.perceptron'}),
      (b:Skill {skill_id: 'ai.neural.layers'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Layers before activation functions
MATCH (a:Skill {skill_id: 'ai.neural.layers'}),
      (b:Skill {skill_id: 'ai.neural.activation'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Activation before training (need to understand the network before learning how it trains)
MATCH (a:Skill {skill_id: 'ai.neural.activation'}),
      (b:Skill {skill_id: 'ai.neural.training'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Conceptual training before mathematical backprop
MATCH (a:Skill {skill_id: 'ai.neural.training'}),
      (b:Skill {skill_id: 'ai.neural.training.advanced'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Also need supervised evaluation to appreciate training curves
MATCH (a:Skill {skill_id: 'ai.supervised.evaluation'}),
      (b:Skill {skill_id: 'ai.neural.training.advanced'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// Layers before CNN (CNN is a specialized architecture)
MATCH (a:Skill {skill_id: 'ai.neural.layers'}),
      (b:Skill {skill_id: 'ai.neural.cnn'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Layers before RNN
MATCH (a:Skill {skill_id: 'ai.neural.layers'}),
      (b:Skill {skill_id: 'ai.neural.rnn'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

// Both RNN and training.advanced before transformers
MATCH (a:Skill {skill_id: 'ai.neural.rnn'}),
      (b:Skill {skill_id: 'ai.neural.transformer'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.neural.training.advanced'}),
      (b:Skill {skill_id: 'ai.neural.transformer'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// Transformers connect to LLMs
MATCH (a:Skill {skill_id: 'ai.neural.transformer'}),
      (b:Skill {skill_id: 'ai.generative.llm.basics'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// ============================================================
// ETHICS CHAIN
// ============================================================

MATCH (a:Skill {skill_id: 'ai.foundations.data'}),
      (b:Skill {skill_id: 'ai.ethics.privacy'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

MATCH (a:Skill {skill_id: 'ai.supervised.classification.level1'}),
      (b:Skill {skill_id: 'ai.ethics.bias'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

MATCH (a:Skill {skill_id: 'ai.ethics.bias'}),
      (b:Skill {skill_id: 'ai.ethics.fairness'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.supervised.evaluation'}),
      (b:Skill {skill_id: 'ai.ethics.fairness'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

// ============================================================
// GENERATIVE AI CHAIN
// ============================================================

MATCH (a:Skill {skill_id: 'ai.foundations.patterns'}),
      (b:Skill {skill_id: 'ai.generative.llm.basics'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'soft'}]->(b);

MATCH (a:Skill {skill_id: 'ai.generative.llm.basics'}),
      (b:Skill {skill_id: 'ai.generative.llm.limitations'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);

MATCH (a:Skill {skill_id: 'ai.generative.llm.basics'}),
      (b:Skill {skill_id: 'ai.generative.prompt'})
CREATE (a)-[:REQUIRED_BEFORE {strength: 'hard'}]->(b);
