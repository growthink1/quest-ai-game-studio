# Quest Competency Graph Index
*Last Updated: 2026-03-23*

## Summary
- **Total skills:** 24
- **Prerequisite edges:** 29 (20 hard, 9 soft)
- **Domains covered:** Foundations, Supervised Learning, Neural Networks, Ethics, Generative AI
- **Domains pending:** Unsupervised Learning, Reinforcement Learning

---

## Skill Inventory

| skill_id | Name | Bloom | Age Min | Difficulty | Interactions |
|---|---|---|---|---|---|
| `ai.foundations.what-is-ai` | What Is AI? | Understand | early_elem | 0.10–0.45 | 5 |
| `ai.foundations.data` | What Is Data? | Understand | early_elem | 0.15–0.50 | 6 |
| `ai.foundations.patterns` | Pattern Recognition | Apply | early_elem | 0.20–0.55 | 7 |
| `ai.foundations.algorithms` | What Is an Algorithm? | Understand | upper_elem | 0.25–0.60 | 6 |
| `ai.foundations.training` | How AI Learns | Understand | upper_elem | 0.30–0.65 | 8 |
| `ai.supervised.classification.level1` | Binary Classification | Understand | upper_elem | 0.30–0.65 | 8 |
| `ai.supervised.classification.level2` | Multi-Class Classification | Apply | upper_elem | 0.40–0.75 | 8 |
| `ai.supervised.regression.level1` | Predicting Continuous Values | Understand | upper_elem | 0.35–0.70 | 7 |
| `ai.supervised.training` | Training & Test Sets | Understand | upper_elem | 0.40–0.75 | 9 |
| `ai.supervised.evaluation` | Model Evaluation | Analyze | hs | 0.50–0.85 | 10 |
| `ai.neural.perceptron` | The Perceptron | Understand | upper_elem | 0.30–0.65 | 7 |
| `ai.neural.layers` | Layers in a Neural Network | Understand | upper_elem | 0.35–0.70 | 8 |
| `ai.neural.activation` | Activation Functions | Understand | hs | 0.45–0.75 | 8 |
| `ai.neural.training` | How Neural Networks Learn | Understand | hs | 0.50–0.80 | 10 |
| `ai.neural.training.advanced` | Gradient Descent & Backprop | Analyze | hs | 0.60–0.88 | 12 |
| `ai.neural.cnn` | Convolutional Neural Networks | Understand | hs | 0.55–0.82 | 10 |
| `ai.neural.rnn` | Recurrent Networks & Memory | Understand | hs | 0.58–0.85 | 10 |
| `ai.neural.transformer` | Transformers & Attention | Analyze | hs | 0.62–0.90 | 12 |
| `ai.ethics.bias` | Bias in AI | Analyze | upper_elem | 0.35–0.70 | 9 |
| `ai.ethics.fairness` | AI Fairness | Evaluate | hs | 0.55–0.85 | 10 |
| `ai.ethics.privacy` | Data Privacy & AI | Understand | upper_elem | 0.25–0.60 | 7 |
| `ai.generative.llm.basics` | What Is a Language Model? | Understand | upper_elem | 0.35–0.70 | 8 |
| `ai.generative.llm.limitations` | LLM Limitations & Hallucinations | Evaluate | upper_elem | 0.40–0.75 | 9 |
| `ai.generative.prompt` | Prompt Engineering Basics | Apply | upper_elem | 0.30–0.65 | 8 |

**Total estimated interactions to graph completion: ~211**

---

## Prerequisite Graph (key chains)

```
early_elem entry points:
  what-is-ai → data → patterns → algorithms → training
                                                 ↓               ↓
                             supervised.classification.level1   neural.perceptron
                                      ↓                              ↓
                             classification.level2           neural.layers
                             supervised.training              ↓          ↓
                                      ↓             activation       cnn, rnn
                             supervised.evaluation              ↓       ↓
                                      ↓             neural.training  transformer → llm.basics
                             ethics.fairness ←────  neural.training.advanced      ↓
                                                                        llm.limitations
                                                                        prompt
```

---

## Pending Domains

| Domain | Priority | Reason |
|---|---|---|
| `ai.unsupervised` | Medium | Clustering, dimensionality reduction — natural contrast to supervised |
| `ai.rl` | High | Directly relevant to Quest's adaptive policy-service; strong game mechanics potential |
| `ai.generative.diffusion` | Low | Image generation — compelling but complex prerequisite chain |

---

## How to Use

**Run skills:** `neo4j-shell < design/competency-graph/skills.cypher`
**Run relationships:** `neo4j-shell < design/competency-graph/relationships.cypher`
**Or via Docker:**
```bash
docker exec -i quest-neo4j cypher-shell -u neo4j -p password < design/competency-graph/skills.cypher
docker exec -i quest-neo4j cypher-shell -u neo4j -p password < design/competency-graph/relationships.cypher
```

**Verify graph:**
```cypher
MATCH (s:Skill) RETURN count(s) AS total_skills;
MATCH ()-[r:REQUIRED_BEFORE]->() RETURN count(r) AS total_edges;
MATCH path = (start:Skill)-[:REQUIRED_BEFORE*]->(end:Skill)
WHERE NOT (start)<-[:REQUIRED_BEFORE]-()
RETURN start.skill_id AS entry_point, length(path) AS depth
ORDER BY depth DESC LIMIT 5;
```
