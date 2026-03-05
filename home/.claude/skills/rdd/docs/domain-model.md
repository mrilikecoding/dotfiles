# Domain Model: Pedagogical RDD

## Concepts (Nouns)

| Term | Definition | Related Terms |
|------|-----------|---------------|
| Opacity Problem | The compounding gap between what AI generates and what the user understands, where each layer of uncomprehended system becomes a foundation for the next. | Metacognitive Illusion, Tacit Knowledge |
| Epistemic Action | An action performed to build understanding of a problem, not to advance toward a solution. Term from Kirsh & Maglio (1994). Contrasts with Pragmatic Action. | Pragmatic Action, Epistemic Gate |
| Pragmatic Action | An action performed to advance toward a goal or produce output. Can be safely automated without learning loss. | Epistemic Action |
| Epistemic Act | A specific, structured cognitive activity performed by the user at an RDD gate, drawn from one of six pedagogical frameworks. The concrete realization of epistemic action preservation within the methodology. | Epistemic Gate, Self-Explanation, Elaborative Interrogation, Retrieval Practice, Articulation, Reflection |
| Gate | A transition point between RDD phases where the user engages with the phase's artifact before proceeding. | Approval Gate, Epistemic Gate, Phase |
| Approval Gate | A gate where the user reviews and accepts an artifact without producing anything. The current RDD pattern. Does not activate learning mechanisms. Avoid: this is the pattern being replaced. | Gate |
| Epistemic Gate | A gate that requires the user to perform one or more Epistemic Acts — producing a targeted reconstruction, prediction, or explanation — before proceeding. The proposed replacement for Approval Gates. | Gate, Epistemic Act, Grounding Move |
| Artifact | A document produced by an RDD phase (essay, domain model, ADR, system design, code). | Epistemic Artifact, Phase |
| Epistemic Artifact | An artifact that serves simultaneously as a project deliverable and as an instrument of knowledge advancement. Term from Scardamalia & Bereiter. All RDD artifacts should be treated as epistemic artifacts. | Artifact |
| Phase | A discrete stage in the RDD pipeline (RESEARCH, MODEL, DECIDE, ARCHITECT, BUILD). Each phase produces an artifact and ends at a gate. | Gate, Artifact, Pipeline |
| Pipeline | The ordered sequence of RDD phases from RESEARCH through BUILD. Epistemic acts at each gate compound across the pipeline. | Phase |
| Self-Explanation | Epistemic act: the user explains artifact elements in their own words. Constructive, integrative, and error-correcting. From Chi (1994). Strongest general-purpose epistemic act. | Epistemic Act |
| Elaborative Interrogation | Epistemic act: the user answers "why does this make sense?" Lightest-weight intervention. Forces connection of new material to prior knowledge. From Pressley (1987). | Epistemic Act |
| Retrieval Practice | Epistemic act: the user reconstructs key elements from memory before re-reading the artifact. Strongest for long-term retention. From Roediger & Karpicke (2006). | Epistemic Act |
| Articulation | Epistemic act: the user explicitly states their knowledge and reasoning about the artifact. From Collins, Brown, & Newman (1987). Transforms approval into active knowledge construction. | Epistemic Act |
| Reflection | Epistemic act in two modes. Reflection-on-action: examining what was learned after a phase completes. Reflection-in-action: thinking about the work while doing it (e.g., predicting test outcomes during BUILD). From Schon (1983). | Epistemic Act |
| Fading | The gradual withdrawal of AI-generated scaffolding as the user's expertise grows. Across RDD cycles, the generative burden shifts from AI toward user. | Scaffolding, Dreyfus Stage |
| Scaffolding | Temporary support that enables the user to engage with tasks beyond their current ability. RDD's phased pipeline provides structural scaffolding. Must fade to avoid becoming a permanent crutch. | Fading |
| Metacognitive Prompt | An explicit question embedded in a gate that triggers the user's reflection on their own understanding ("What changed? What surprised you? What would you explain differently?"). The mechanism that determines whether gates produce learning or just artifacts. | Epistemic Gate, Reflection |
| Metacognitive Illusion | The false sense that understanding is strong because AI output is strong. Output quality and human understanding are independent variables. Term derived from Bjork. | Opacity Problem, Approval Gate |
| Grounding | The collaborative process of establishing shared understanding between user and AI. Requires active verification, not just approval. From Clark & Brennan (1991). | Grounding Move, Common Ground |
| Grounding Move | A specific communicative act that verifies shared understanding. Epistemic acts at gates function as grounding moves — they signal to the AI what the user actually understood, not just that the output looked right. | Grounding, Epistemic Act |
| Common Ground | The mutual knowledge, beliefs, and assumptions shared between user and AI at any point in the pipeline. Enriched by epistemic acts; eroded by approval-only gates. | Grounding |
| Tacit Knowledge | Knowledge the user holds but has not articulated. A primary source of requirements defects. Epistemic acts force tacit knowledge into explicit form, preventing hidden defects. | Opacity Problem, Grounding |
| Desirable Difficulty | A condition that makes learning feel harder but produces better long-term retention. Epistemic acts introduce targeted desirable difficulties at gates. From Bjork (1994). | Epistemic Act |
| Cognitive Level | The depth of cognitive engagement, mapped to Bloom's taxonomy (Remember, Understand, Apply, Analyze, Evaluate, Create). Approval gates engage only Evaluate. Epistemic gates engage Analyze and Create. | Epistemic Gate, Approval Gate |
| Dreyfus Stage | The user's current stage of skill acquisition (Novice → Expert). Determines how much scaffolding is appropriate and when fading should occur. | Fading, Scaffolding |
| Maintenance Cliff | The point where initial velocity advantages of AI-assisted development invert due to accumulated opacity. Debugging and extending uncomprehended code takes longer than manual development would have. The concrete, measurable consequence of the Opacity Problem. | Opacity Problem, Approval Gate |
| Context Window Ceiling | The hard constraint where system complexity exceeds what AI can reason about holistically. At this point, the human's structural understanding becomes the irreplaceable bridge — the long-term architectural memory that the AI's context cannot be. | Opacity Problem, Maintenance Cliff |
| Authority | The standing to explain, decide about, and take responsibility for a system. Requires understanding — ownership without comprehension is commissioning, not authorship. The word does double duty: knowledge sufficient to explain, and standing sufficient to decide. Authority is what Invariant 0 measures. | Common Ground, Epistemic Gate |

**Synonym aliases to avoid in ADRs and skill text:**

| Use This | Not This |
|----------|----------|
| Epistemic Gate | Generative Gate, Generation Gate |
| Epistemic Act | Epistemic Task, Learning Activity, Cognitive Exercise |
| Fading | Withdrawal, Reduction |
| Approval Gate | Passive Gate, Review Gate |
| Metacognitive Prompt | Reflection Question, Learning Prompt |
| Grounding Move | Verification Step, Understanding Check |

## Actions (Verbs)

| Action | Actor | Subject | Description |
|--------|-------|---------|-------------|
| Generate | AI | Artifact | AI produces a phase artifact (essay, domain model, ADR, system design, code) at full speed and depth |
| Approve | User | Artifact | User reviews and accepts an artifact without producing anything. The pattern being replaced. |
| Self-Explain | User | Artifact | User explains key elements of an artifact in their own words, activating constructive, integrative, and error-correcting mechanisms |
| Interrogate | User | Artifact | User asks "why does this make sense?" about a decision, boundary, or design choice, connecting it to prior knowledge |
| Retrieve | User | Domain knowledge | User reconstructs key concepts, relationships, or decisions from memory before re-reading the artifact |
| Articulate | User | Understanding | User explicitly states what they know and why, transforming internal knowledge into external, reviewable form |
| Reflect | User | Phase outcome | User examines what changed in their understanding (on-action) or predicts outcomes before seeing them (in-action) |
| Ground | User + AI | Common Ground | User and AI collaboratively verify shared understanding through epistemic acts, enriching context for subsequent phases |
| Surface | User | Tacit Knowledge | User makes implicit assumptions explicit through epistemic acts, preventing hidden defects |
| Fade | Methodology | Scaffolding | The methodology reduces AI-generated assistance as user expertise grows across RDD cycles |

## Relationships

- Pipeline **contains ordered** Phases
- Phase **produces** Artifact
- Phase **ends at** Gate
- Gate **requires** one or more Epistemic Acts
- Epistemic Act **activates** learning mechanisms (Generation Effect, Desirable Difficulty)
- Epistemic Act **functions as** Grounding Move
- Epistemic Act **surfaces** Tacit Knowledge
- Grounding Move **enriches** Common Ground
- Common Ground **informs** subsequent Phase (compounding quality effect)
- Approval Gate **produces** Metacognitive Illusion (risk)
- Approval Gate **erodes** Common Ground (risk)
- Metacognitive Prompt **triggers** Reflection
- Scaffolding **requires** Fading over time
- Fading **is governed by** Dreyfus Stage
- Artifact **serves as** Epistemic Artifact (dual role: deliverable + learning instrument)
- Opacity Problem **compounds across** Phases when Epistemic Acts are absent
- Opacity Problem **manifests as** Maintenance Cliff (at project scale)
- Epistemic Gate **prevents** Maintenance Cliff (by interrupting compounding at each phase transition)
- Context Window Ceiling **necessitates** human structural understanding (AI cannot substitute beyond this point)
- Epistemic Gate **builds** Authority (through accumulated understanding across the pipeline)
- Authority **requires** understanding (ownership without comprehension is commissioning, not authorship)

## Invariants

0. **The user should be able to speak with authority about what was built.** After completing an RDD cycle, the user should be able to explain the system's design rationale, key decisions, and domain vocabulary without AI assistance. This is the outcome all other invariants serve. If the methodology satisfies invariants 1-7 but the user cannot do this, the methodology has failed.

1. **Understanding requires generation, not review.** Passive review of AI output does not produce durable understanding. Every gate must require the user to produce something — an explanation, prediction, reconstruction, or articulation — not merely assess something.

2. **Epistemic acts are mandatory at every gate.** No phase transition may consist solely of approval. At minimum, one epistemic act must be performed before proceeding.

3. **Pragmatic actions may be automated; epistemic actions may not.** AI handles generation, search, formatting, and first drafts (pragmatic). The user handles explanation, prediction, retrieval, and articulation (epistemic). The boundary between these categories is the core design decision.

4. **Epistemic cost must remain lightweight.** Each gate's epistemic acts must take minutes, not hours. If the cost becomes burdensome, users will circumvent it — either by abandoning the methodology or by treating acts as perfunctory. Target: 5-10 minutes per gate.

5. **Approval is not grounding.** Verifying that output looks correct does not establish shared understanding. Epistemic acts function as grounding moves that verify alignment between user intent and AI interpretation.

6. **Scaffolding must fade.** Constant AI assistance at a fixed level is a crutch, not scaffolding. Across RDD cycles, the methodology should shift generative burden toward the user as expertise grows.

7. **Epistemic acts are bidirectional.** Each act simultaneously builds user understanding and enriches AI context for subsequent phases. This is not a side effect — it is a core mechanism. The compounding quality effect depends on both directions operating.

## Amendment Log

| # | Date | Invariant | Change | Propagation |
|---|------|-----------|--------|-------------|
| 1 | 2026-03-05 | Invariant 0 | ADDED: outcome-level invariant establishing that the user must be able to explain what was built without AI assistance | Essay §9 should reference this as the success criterion; all ADRs should trace back to it |
| 2 | 2026-03-05 | Concepts | ADDED: Maintenance Cliff, Context Window Ceiling. ADDED relationships: Opacity Problem manifests as Maintenance Cliff; Epistemic Gate prevents Maintenance Cliff; Context Window Ceiling necessitates human structural understanding | Informed by essay §8 (requirements-only counterargument) |
