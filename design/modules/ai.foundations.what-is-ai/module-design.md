# Module Design: What Is Artificial Intelligence?
**skill_id:** `ai.foundations.what-is-ai`
**Version:** 1.0 — 2026-03-23

---

## Learning Objective
By the end of this module, learners can:
- Describe AI as technology that learns from examples to make decisions or predictions
- Give at least two real-world examples of AI they encounter in daily life
- Explain the difference between AI making a decision and a person making a decision

**Bloom's Level:** Understand
**Evidence of learning:** Learner correctly identifies AI vs. non-AI systems in novel scenarios (not ones seen during the module)

---

## Target Age Band
**Primary:** early_elem (age 6–9)
**Constraints:**
- No free text input — all responses via selection or drag-and-drop
- Audio narration accompanies all text
- Vocabulary: "learns", "examples", "decides", "predicts" — no "algorithm", "model", "train"
- Analogies: concrete and observable (teaching a dog tricks, sorting M&Ms by color)
- Touch targets minimum 80px
- Session length target: 8–10 minutes

---

## Quest Narrative Context
**Setting:** The learner arrives in the AI Frontier — a world where AI Guardians help the inhabitants with decisions. The first Guardian they meet, ARIA, seems magical but is actually just very good at recognizing patterns. The module's narrative arc: "ARIA isn't magic — you can understand exactly how she works."

**Narrative hook:** ARIA is sorting mail for the town. Some letters go to houses, some to the market, some to the school. She's never wrong. The learner's goal: figure out how ARIA knows where each letter goes.

---

## Prerequisite Activation
This is the entry-point skill — no prerequisites in the competency graph.
Use a "prior knowledge probe" interaction instead:
- Interaction 1: "Have you ever seen a computer do something that seemed smart? Tell ARIA about it."
  (Multiple choice: suggest 4 concrete examples — voice assistant, photo app, game AI, recommendation)
  Purpose: activate existing mental models, not assess — all answers are "correct"

---

## Module Arc

### Entry: Interactions 1–2
**Goal:** Orient the learner in the narrative, activate prior knowledge, establish that AI does something understandable

**Interaction 1 — Prior knowledge activation**
- Type: Multiple select (pick all that apply)
- Prompt: "ARIA wants to know — have you seen computers do any of these things?"
- Options: answer a question you asked | recognize your face in a photo | recommend a video | play a game against you
- Mechanic: All selections are valid. ARIA responds warmly to whatever is selected.
- Learning signal: NOT a knowledge check — no `response_correct` signal, `mastery_prior` unchanged
- Difficulty: 0.10 (near-zero — intentionally easy, reduces anxiety)
- Narrative: "Wow, you've already met AI! Let me show you what's really going on..."

**Interaction 2 — What makes something AI?**
- Type: Sort two piles ("AI" vs "Not AI") — drag-and-drop
- Items: calculator (not AI), ARIA sorting mail (AI), traffic light timer (not AI), photo app recognizing a face (AI)
- Key distinction: AI learns from examples. A calculator follows a fixed rule every time.
- Hint (if wrong): "Does it learn from examples, or does it always follow the same rule?"
- Difficulty: 0.20
- Bloom's: Remember (can learner apply the simple definition?)
- Narrative: "See the difference? I learned by looking at thousands of letters. A calculator just does the same math every time."

---

### Build: Interactions 3–5
**Goal:** Establish the core concept — AI learns from examples

**Interaction 3 — How ARIA learned**
- Type: Sequence ordering
- Prompt: "Help ARIA remember how she learned to sort mail. Put these in order:"
  1. Look at thousands of example letters with the right address
  2. Notice patterns (letters to houses look different from letters to school)
  3. Use those patterns on new letters
- Correct: 1 → 2 → 3
- Difficulty: 0.28
- Bloom's: Understand (can learner sequence the learning process?)
- Hint 1: "What had to come first — seeing examples, or using what she learned?"
- Narrative payoff: "That's exactly right! I didn't start knowing — I started learning."

**Interaction 4 — Examples make AI smarter**
- Type: Slider comparison
- Prompt: "ARIA has seen different amounts of mail. Which ARIA would be better at sorting new letters?"
- Visual: ARIA-A has seen 5 letters, ARIA-B has seen 5,000 letters
- Answer: ARIA-B (more examples = better patterns)
- Difficulty: 0.30
- Bloom's: Understand (grasping why data volume matters)
- Hint 1: "Think about learning to ride a bike — would you get better after 5 tries or 5,000 tries?"
- Key misconception guard: Some learners think "smarter AI = faster AI." Reframe: more examples, not more speed.

**Interaction 5 — AI learns, but it can be wrong**
- Type: Scenario judgment
- Prompt: "A new letter arrives in an envelope ARIA has never seen before. What might happen?"
- Options: A) ARIA gets it right because she's smart | B) ARIA might get it wrong because it's different from her examples | C) ARIA refuses to sort it
- Answer: B
- Difficulty: 0.38
- Bloom's: Understand (limitations of learned patterns)
- Hint 1: "Has ARIA seen envelopes like this before in her training?"
- Misconception guard: Prevents "AI is always right" mental model

---

### Practice: Interactions 6–8
**Goal:** Apply the concept to novel scenarios — AI in the learner's world

**Interaction 6 — Spot the AI**
- Type: Multiple choice with justification
- Prompt: "Which of these is using AI? Choose the one that LEARNS from examples."
- Options: A) A clock that shows the time | B) A music app that recommends songs you might like | C) A light switch | D) A calculator
- Answer: B
- Difficulty: 0.42
- Bloom's: Apply (transfer to new domain — music recommendations)
- Hint 1: "Which one changes its suggestions based on what you've listened to before?"
- Hint 2: "A clock always shows the same time for the same moment. Does this thing always give the same answer?"

**Interaction 7 — Design your own AI**
- Type: Construction task (drag-and-drop)
- Prompt: "You want to build an AI that recognizes dogs in photos. Drag what you need into the AI's learning box."
- Items available: 1,000 photos of dogs (✓), 1,000 photos of cats (✓), 3 photos of dogs (✗ — too few), a rulebook about dogs (✗ — not how AI works), lots of computing time (✓)
- Answer: photos of dogs + photos of cats (contrast examples) + computing time
- Difficulty: 0.50
- Bloom's: Apply (can learner construct a simple AI training scenario?)
- Hint 1: "ARIA needed to see LOTS of examples to learn. How many do you have?"
- Hint 2: "Would it help ARIA to also see what's NOT a letter, so she knows the difference?"
- Misconception guard: Rulebook option addresses "AI follows human-written rules" misconception

**Interaction 8 — AI vs. Human decision**
- Type: Comparison sort
- Prompt: "Sort these decisions — is a person or an AI better suited for each?"
- Items: deciding if a photo shows a cat (AI), comforting a sad friend (person), recommending a movie (AI), choosing what's fair (person)
- Difficulty: 0.55
- Bloom's: Apply + begin Analyze (comparing strengths)
- Hint 1: "AI is great at finding patterns in lots of data. People are better at understanding feelings and fairness."
- Narrative: "See — I'm really good at patterns, but you're better at things that need understanding and caring."

---

### Mastery Check: Interactions 9–10
**Goal:** Demonstrate understanding independently — no hints

**Interaction 9 — Novel scenario (no hints)**
- Type: Multiple choice
- Prompt: "A new app watches which jokes you laugh at and starts showing you more jokes like those. Is this AI? Why?"
- Options:
  A) Yes — it learns from examples of what you find funny ✓
  B) No — it's just a computer program
  C) Yes — because it's on a phone
  D) No — only robots are AI
- Answer: A
- Difficulty: 0.58
- Bloom's: Understand applied to novel domain
- No hints — mastery check

**Interaction 10 — Mastery gate question (no hints)**
- Type: Short constructed response (age-adapted: select words to complete a sentence)
- Prompt: "Complete ARIA's explanation: 'I am AI because I _____ from _____ to make _____'"
- Word bank: learn / guess / examples / rules / decisions / mistakes
- Correct: learn / examples / decisions
- Difficulty: 0.62
- Bloom's: Understand (can construct the core definition)
- Mastery gate: mastery_posterior ≥ 0.75 to advance (lower than default 0.80 — entry skill, don't gate too harshly)

---

## Knowledge Check Placement

| Interaction | Type | Bloom's | Difficulty | Signal |
|---|---|---|---|---|
| 1 | Prior knowledge probe | — | 0.10 | No BKT signal |
| 2 | Formative | Remember | 0.20 | BKT update |
| 3 | Formative | Understand | 0.28 | BKT update |
| 4 | Formative | Understand | 0.30 | BKT update |
| 5 | Formative | Understand | 0.38 | BKT update |
| 6 | Formative | Apply | 0.42 | BKT update |
| 7 | Formative | Apply | 0.50 | BKT update |
| 8 | Formative | Apply | 0.55 | BKT update |
| 9 | Mastery check | Understand | 0.58 | BKT update |
| 10 | Mastery gate | Understand | 0.62 | Mastery threshold check |

Difficulty progression: 0.10 → 0.20 → 0.28 → 0.30 → 0.38 → 0.42 → 0.50 → 0.55 → 0.58 → 0.62
Max jump between interactions: 0.10 — within the ≤0.15 rule ✓

---

## Narrative Arc

**Setup:** ARIA sorts mail perfectly. The learner thinks she's magic.
**Development:** Through each interaction, the learner discovers ARIA's "magic" is really pattern learning. She's not magic — she's smart in a specific way. And she can be wrong.
**Resolution:** The learner completes ARIA's sentence and realizes they understand AI. ARIA says: "See? You just described what I am. You understand me now."
**Unlock payoff:** A map of the AI Frontier appears. The learner can see the next skill unlocked: "What Is Data?" with a door to ARIA's training archive.

---

## Misconception Guards

| Misconception | Where addressed | How addressed |
|---|---|---|
| "AI is magic / can't be understood" | Narrative frame | ARIA explicitly demystifies herself throughout |
| "AI is always right" | Interaction 5 | Scenario where ARIA might be wrong on novel input |
| "AI follows rules humans wrote" | Interaction 7 | Rulebook distractor — explicitly rejected |
| "AI = robots" | Interaction 10 distractor D | Listed as incorrect option |
| "More data = faster AI" | Interaction 4 hint | Reframed as better patterns, not faster |

---

## BKT Parameters (defaults — calibrate after first 100 learners)

| Parameter | Value | Rationale |
|---|---|---|
| P(L0) | 0.15 | Most early_elem learners have no prior AI concept |
| P(T) | 0.35 | Relatively fast to learn — concrete concept with good analogies |
| P(G) | 0.25 | 4-option MC — random chance is 0.25 |
| P(S) | 0.08 | Low slip — once understood, this concept doesn't easily slip |

---

## Validation Status

- [ ] ai-sme review (content accuracy)
- [ ] pedagogy-director review (Bloom's alignment, CLT, age-band)
- [ ] assessment-designer review (mastery check validity)
- [ ] learning-audit run (`/learning-audit design/modules/ai.foundations.what-is-ai/module-design.md`)
- [ ] Approved to ship: PENDING
