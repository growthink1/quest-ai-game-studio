// Quest AI Learning Game — Competency Graph
// Skills: AI Foundations Domain
// Last Updated: 2026-03-23
// Managed by: curriculum-designer agent

// ============================================================
// FOUNDATIONS
// ============================================================

CREATE (s1:Skill {
  skill_id: 'ai.foundations.what-is-ai',
  name: 'What Is Artificial Intelligence?',
  description: 'Learner can describe what AI is and give at least two real-world examples of AI in their daily life.',
  bloom_level: 'Understand',
  age_band_min: 'early_elem',
  difficulty_min: 0.10,
  difficulty_max: 0.45,
  mastery_threshold: 0.75,
  estimated_interactions: 5
});

CREATE (s2:Skill {
  skill_id: 'ai.foundations.data',
  name: 'What Is Data?',
  description: 'Learner can explain what data is, identify features and labels in a simple dataset, and explain why AI needs data to learn.',
  bloom_level: 'Understand',
  age_band_min: 'early_elem',
  difficulty_min: 0.15,
  difficulty_max: 0.50,
  mastery_threshold: 0.80,
  estimated_interactions: 6
});

CREATE (s3:Skill {
  skill_id: 'ai.foundations.patterns',
  name: 'Pattern Recognition Basics',
  description: 'Learner can identify a pattern in data examples and explain how recognizing patterns helps AI make predictions.',
  bloom_level: 'Apply',
  age_band_min: 'early_elem',
  difficulty_min: 0.20,
  difficulty_max: 0.55,
  mastery_threshold: 0.80,
  estimated_interactions: 7
});

CREATE (s4:Skill {
  skill_id: 'ai.foundations.algorithms',
  name: 'What Is an Algorithm?',
  description: 'Learner can define an algorithm as a set of instructions and explain how AI uses algorithms to learn from data.',
  bloom_level: 'Understand',
  age_band_min: 'upper_elem',
  difficulty_min: 0.25,
  difficulty_max: 0.60,
  mastery_threshold: 0.80,
  estimated_interactions: 6
});

CREATE (s5:Skill {
  skill_id: 'ai.foundations.training',
  name: 'How AI Learns (Training)',
  description: 'Learner can explain that AI learns by finding patterns in training data and improving through feedback.',
  bloom_level: 'Understand',
  age_band_min: 'upper_elem',
  difficulty_min: 0.30,
  difficulty_max: 0.65,
  mastery_threshold: 0.80,
  estimated_interactions: 8
});

// ============================================================
// SUPERVISED LEARNING
// ============================================================

CREATE (s6:Skill {
  skill_id: 'ai.supervised.classification.level1',
  name: 'Binary Classification Basics',
  description: 'Learner can explain what a binary classifier does and identify real-world binary classification problems.',
  bloom_level: 'Understand',
  age_band_min: 'upper_elem',
  difficulty_min: 0.30,
  difficulty_max: 0.65,
  mastery_threshold: 0.80,
  estimated_interactions: 8
});

CREATE (s7:Skill {
  skill_id: 'ai.supervised.classification.level2',
  name: 'Multi-Class Classification',
  description: 'Learner can distinguish binary from multi-class classification and identify appropriate use cases for each.',
  bloom_level: 'Apply',
  age_band_min: 'upper_elem',
  difficulty_min: 0.40,
  difficulty_max: 0.75,
  mastery_threshold: 0.80,
  estimated_interactions: 8
});

CREATE (s8:Skill {
  skill_id: 'ai.supervised.regression.level1',
  name: 'Predicting Continuous Values',
  description: 'Learner can explain regression as predicting a number (not a category) and give real-world examples.',
  bloom_level: 'Understand',
  age_band_min: 'upper_elem',
  difficulty_min: 0.35,
  difficulty_max: 0.70,
  mastery_threshold: 0.80,
  estimated_interactions: 7
});

CREATE (s9:Skill {
  skill_id: 'ai.supervised.training',
  name: 'Training and Test Sets',
  description: 'Learner can explain why data is split into training and test sets and what overfitting means.',
  bloom_level: 'Understand',
  age_band_min: 'upper_elem',
  difficulty_min: 0.40,
  difficulty_max: 0.75,
  mastery_threshold: 0.80,
  estimated_interactions: 9
});

CREATE (s10:Skill {
  skill_id: 'ai.supervised.evaluation',
  name: 'Model Evaluation Basics',
  description: 'Learner can explain accuracy, precision, and recall at a conceptual level and choose the right metric for a given problem.',
  bloom_level: 'Analyze',
  age_band_min: 'hs',
  difficulty_min: 0.50,
  difficulty_max: 0.85,
  mastery_threshold: 0.80,
  estimated_interactions: 10
});

// ============================================================
// AI ETHICS
// ============================================================

CREATE (s11:Skill {
  skill_id: 'ai.ethics.bias',
  name: 'Bias in AI',
  description: 'Learner can explain what algorithmic bias is, identify how it enters AI systems, and give a real-world example of harmful bias.',
  bloom_level: 'Analyze',
  age_band_min: 'upper_elem',
  difficulty_min: 0.35,
  difficulty_max: 0.70,
  mastery_threshold: 0.80,
  estimated_interactions: 9
});

CREATE (s12:Skill {
  skill_id: 'ai.ethics.fairness',
  name: 'AI Fairness',
  description: 'Learner can explain that fairness has multiple definitions, identify a trade-off between fairness metrics, and explain why no single definition is always correct.',
  bloom_level: 'Evaluate',
  age_band_min: 'hs',
  difficulty_min: 0.55,
  difficulty_max: 0.85,
  mastery_threshold: 0.80,
  estimated_interactions: 10
});

CREATE (s13:Skill {
  skill_id: 'ai.ethics.privacy',
  name: 'Data Privacy and AI',
  description: 'Learner can explain why AI systems need data, identify privacy risks in data collection, and describe consent in plain terms.',
  bloom_level: 'Understand',
  age_band_min: 'upper_elem',
  difficulty_min: 0.25,
  difficulty_max: 0.60,
  mastery_threshold: 0.80,
  estimated_interactions: 7
});

// ============================================================
// GENERATIVE AI
// ============================================================

CREATE (s14:Skill {
  skill_id: 'ai.generative.llm.basics',
  name: 'What Is a Language Model?',
  description: 'Learner can explain that language models predict the next word based on patterns in text, and describe what training data is for an LLM.',
  bloom_level: 'Understand',
  age_band_min: 'upper_elem',
  difficulty_min: 0.35,
  difficulty_max: 0.70,
  mastery_threshold: 0.80,
  estimated_interactions: 8
});

CREATE (s15:Skill {
  skill_id: 'ai.generative.llm.limitations',
  name: 'LLM Limitations and Hallucinations',
  description: 'Learner can explain what hallucination means in LLMs, why it happens, and describe strategies for verifying AI-generated information.',
  bloom_level: 'Evaluate',
  age_band_min: 'upper_elem',
  difficulty_min: 0.40,
  difficulty_max: 0.75,
  mastery_threshold: 0.80,
  estimated_interactions: 9
});

CREATE (s16:Skill {
  skill_id: 'ai.generative.prompt',
  name: 'Prompt Engineering Basics',
  description: 'Learner can write a clear, specific prompt for an LLM and explain why prompt quality affects output quality.',
  bloom_level: 'Apply',
  age_band_min: 'upper_elem',
  difficulty_min: 0.30,
  difficulty_max: 0.65,
  mastery_threshold: 0.80,
  estimated_interactions: 8
});
