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
| Artifact | A document produced by an RDD phase (essay, product discovery document, domain model, ADR, system design, code). | Epistemic Artifact, Phase |
| Epistemic Artifact | An artifact that serves simultaneously as a project deliverable and as an instrument of knowledge advancement. Term from Scardamalia & Bereiter. All RDD artifacts should be treated as epistemic artifacts. | Artifact |
| Phase | A discrete stage in the RDD pipeline (RESEARCH, PRODUCT DISCOVERY, MODEL, DECIDE, ARCHITECT, BUILD). Each phase produces an artifact and ends at a gate. | Gate, Artifact, Pipeline |
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
| Authority | The standing to explain, decide about, and take responsibility for a system — including who it was built for and why. Requires understanding — ownership without comprehension is commissioning, not authorship. The word does double duty: knowledge sufficient to explain, and standing sufficient to decide. Authority is what Invariant 0 measures. | Common Ground, Epistemic Gate, Product Discovery |
| Product Debt | The accumulated gap between what a system does and what users actually need. Analogous to technical debt but invisible in the codebase — it hides in the mismatch between system affordances and user mental models. Product debt compounds as users build workarounds and expectations calcify. | Product Maintenance Cliff, Product Conformance, User Mental Model |
| Product Maintenance Cliff | The point where accumulated product debt makes iteration harder than starting over. Product assumptions encoded in architecture become exponentially more expensive to correct (Boehm's 10-100x cost curve applied to product decisions). Parallel to the technical Maintenance Cliff. | Product Debt, Maintenance Cliff, Inversion Principle |
| Product Discovery | An RDD phase positioned between RESEARCH and MODEL that surfaces user needs, stakeholder maps, value tensions, and assumption inversions. Operates in two modes: forward (greenfield) and backward (existing system audit). Its artifact is written in user language and serves as the Rosetta Stone between product vocabulary and system vocabulary. | Phase, Product Vocabulary, Stakeholder Map, Value Tension, Assumption Inversion |
| Stakeholder Map | A section of the product discovery artifact that identifies everyone affected by the system — both direct stakeholders (who interact with it) and indirect stakeholders (who are affected without interacting). Broader than personas, which represent ideal users. From Friedman's Value Sensitive Design. | Product Discovery, Value Tension |
| User Mental Model | A user's internal representation of how the domain works, expressed in their own language. Mapped during product discovery before the domain model maps how the system thinks the domain works. Divergence between the two is a design signal to be surfaced, not a bug to resolve. From Norman. | Product Discovery, Product Vocabulary, Domain Model |
| Value Tension | A conflict between stakeholder needs, or between user needs and business goals, surfaced during product discovery and passed forward as an open question for DECIDE. Value tensions are held, not resolved prematurely. From Haraway's "staying with the trouble." | Product Discovery, Stakeholder Map |
| Assumption Inversion | The output of applying the Inversion Principle: for each major product assumption, the inverted form and its implications. Produced as a section of the product discovery artifact and used to enrich behavior scenarios in DECIDE. | Inversion Principle, Product Discovery |
| Inversion Principle | A cross-cutting epistemological practice: systematically question assumptions before encoding them in architecture. Inverting assumptions is a fundamental research methodology — it surfaces hidden premises by asking "what if this were wrong?" Product assumptions are the most critical application because they hide in the gap between system affordances and user needs, but the principle applies wherever assumptions can silently harden into structure. Operates at two levels — as a procedural step within /rdd-product and as a habit of mind across RESEARCH, DECIDE, and ARCHITECT. The mechanism serving the product dimension of Invariant 0. | Assumption Inversion, Product Discovery, Authority |
| Product Vocabulary | Terms in user-facing language that describe the domain as stakeholders experience it. Distinct from system vocabulary (domain model terms). Product vocabulary is captured in the product discovery artifact and traced into the domain model via a provenance column. | Product Discovery, User Mental Model, Domain Model |
| Product Conformance | A higher-level conformance audit that checks the system's product assumptions against actual user needs — complementing technical conformance (which checks code against ADRs). Without product conformance, technical conformance ensures the system is consistently wrong. | Product Discovery, Product Debt, Conformance Audit |
| Artifact Legibility | The degree to which an artifact is comprehensible to non-technical stakeholders. Technical artifacts (invariant tables, ADR templates) have low legibility. The product discovery artifact has high legibility because it is written in user language. The legibility gap is a structural problem the product discovery phase addresses. | Artifact, Product Discovery, Product Vocabulary |
| Scoping | A team lead's partial pipeline run (RESEARCH → ARCHITECT, no BUILD) used as a leadership thinking tool to build deep understanding and produce handoff artifacts. The team lead can "speak to" the artifacts — explain and defend decisions — because they went through the gates. BUILD is handed off so the team gains their own understanding through implementation. | Pipeline, Handoff, Authority |
| Pair-RDD | A collaborative mode where two humans run an RDD cycle together, both responding at epistemic gates. Recovers the pair-programming dynamic lost in agentic coding. The gates become a facilitation structure for human-human dialog, not just human-AI dialog. Not yet formalized in the pipeline. | Epistemic Gate, Epistemic Act |
| Research-Engineer | A stakeholder who uses RDD primarily for the research and understanding phases, where the goal is deep comprehension of a problem space rather than (or before) building software. The pipeline's RESEARCH, PRODUCT DISCOVERY, and MODEL phases serve as a structured methodology for investigation — closer to research engineering than traditional software development. | Phase, Pipeline, Scoping |
| Handoff | The act of passing artifacts to a team or specialists. In the scoping use case, the team lead hands off system design and product discovery artifacts after running through ARCHITECT. Before team handoff, the team lead may share artifacts with architecture and product specialists for external review. Real workflow, not yet formalized in the pipeline. | Scoping, External Review, Artifact |
| External Review | Specialist feedback (from architecture or product experts) that flows back into the pipeline before team handoff. The team lead shares artifacts for validation, and feedback re-enters at the relevant phase (product feedback at PRODUCT DISCOVERY, technical feedback at ARCHITECT). Confirmed as real workflow but not yet formalized as a pipeline operation. | Handoff, Product Discovery, Pipeline |

**Synonym aliases to avoid in ADRs and skill text:**

| Use This | Not This |
|----------|----------|
| Epistemic Gate | Generative Gate, Generation Gate |
| Epistemic Act | Epistemic Task, Learning Activity, Cognitive Exercise |
| Fading | Withdrawal, Reduction |
| Approval Gate | Passive Gate, Review Gate |
| Metacognitive Prompt | Reflection Question, Learning Prompt |
| Grounding Move | Verification Step, Understanding Check |
| Product Debt | UX Debt, Design Debt, Experience Debt |
| Value Tension | Value Conflict, Requirements Conflict |
| Inversion Principle | Assumption Questioning, Critical Design Step |
| Stakeholder Map | Persona Map, User Map |
| Product Conformance | Product Audit, UX Audit |
| Scoping | Partial Run, Abbreviated Pipeline |
| Pair-RDD | Collaborative RDD, Pair Research |
| External Review | External Feedback, Specialist Review |
| Handoff | Transfer, Delivery |

## Actions (Verbs)

| Action | Actor | Subject | Description |
|--------|-------|---------|-------------|
| Generate | AI | Artifact | AI produces a phase artifact (essay, product discovery document, domain model, ADR, system design, code) at full speed and depth |
| Approve | User | Artifact | User reviews and accepts an artifact without producing anything. The pattern being replaced. |
| Self-Explain | User | Artifact | User explains key elements of an artifact in their own words, activating constructive, integrative, and error-correcting mechanisms |
| Interrogate | User | Artifact | User asks "why does this make sense?" about a decision, boundary, or design choice, connecting it to prior knowledge |
| Retrieve | User | Domain knowledge | User reconstructs key concepts, relationships, or decisions from memory before re-reading the artifact |
| Articulate | User | Understanding | User explicitly states what they know and why, transforming internal knowledge into external, reviewable form |
| Reflect | User | Phase outcome | User examines what changed in their understanding (on-action) or predicts outcomes before seeing them (in-action) |
| Ground | User + AI | Common Ground | User and AI collaboratively verify shared understanding through epistemic acts, enriching context for subsequent phases |
| Surface | User | Tacit Knowledge | User makes implicit assumptions explicit through epistemic acts, preventing hidden defects |
| Fade | Methodology | Scaffolding | The methodology reduces AI-generated assistance as user expertise grows across RDD cycles |
| Invert | User + AI | Product Assumption | Systematically question a product assumption by stating its opposite and evaluating implications. Produces Assumption Inversions in the product discovery artifact |
| Map Stakeholders | User + AI | System boundary | Identify all direct and indirect stakeholders affected by the system, beyond just the users who interact with it |
| Audit Product Conformance | User + AI | Existing system | In backward mode, extract implicit product assumptions from existing architecture and validate them against actual user needs, producing a Product Debt table |

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
- Product Discovery **produces** Stakeholder Map, User Mental Models, Value Tensions, Assumption Inversions, Product Vocabulary
- Product Discovery **feeds forward into** MODEL (product vocabulary provenance, mental model validation, open questions)
- Product Discovery **feeds forward into** DECIDE (stakeholder needs in ADR context, assumption inversions as scenarios)
- Product Discovery **feeds forward into** ARCHITECT (extended provenance chains from module to user need)
- Product Vocabulary **traces into** Domain Model (via provenance column linking system terms to user-facing origins)
- User Mental Model **validates against** Domain Model (divergence is a design signal, not a bug)
- Value Tension **propagates as** Open Question into MODEL and DECIDE
- Product Debt **accumulates invisibly** when Product Discovery is absent
- Product Debt **manifests as** Product Maintenance Cliff (at project scale)
- Product Discovery **prevents** Product Maintenance Cliff (by surfacing assumptions before they harden into architecture)
- Inversion Principle **serves** Invariant 0 (the mechanism for the product dimension of authority)
- Inversion Principle **cross-cuts** RESEARCH, PRODUCT DISCOVERY, DECIDE, ARCHITECT
- Product Conformance **complements** Technical Conformance (together they close the loop: code matches decisions, decisions match user needs)
- Artifact Legibility **is highest for** Product Discovery artifact (written in user language, walkable as narrative)
- Assumption Inversion **functions as** Epistemic Act (dual purpose: questioning assumptions + building understanding)
- Scoping **is a partial** Pipeline run (RESEARCH → ARCHITECT, handoff instead of BUILD)
- Scoping **produces** Handoff artifacts (product discovery doc + system design)
- External Review **triggers** pipeline re-entry (product feedback → PRODUCT DISCOVERY, technical feedback → ARCHITECT)
- Handoff **transfers** Artifacts to team or specialists
- Pair-RDD **extends** Epistemic Gate (two humans at the gate instead of one)

## Invariants

0. **The user should be able to speak with authority about what was built, who it was built for, and why.** After completing an RDD cycle, the user should be able to explain the system's design rationale, key decisions, domain vocabulary, and the user needs those decisions serve — without AI assistance. This is the outcome all other invariants serve. If the methodology satisfies invariants 1-7 but the user cannot do this, the methodology has failed.

1. **Understanding requires generation, not review.** Passive review of AI output does not produce durable understanding. Every gate must require the user to produce something — an explanation, prediction, reconstruction, or articulation — not merely assess something.

2. **Epistemic acts are mandatory at every gate.** No phase transition may consist solely of approval. At minimum, one epistemic act must be performed before proceeding.

3. **Pragmatic actions may be automated; epistemic actions may not.** AI handles generation, search, formatting, and first drafts (pragmatic). The user handles explanation, prediction, retrieval, and articulation (epistemic). The boundary between these categories is the core design decision.

4. **Epistemic cost must remain lightweight.** Each gate's epistemic acts must take minutes, not hours. If the cost becomes burdensome, users will circumvent it — either by abandoning the methodology or by treating acts as perfunctory. Target: 5-10 minutes per gate.

5. **Approval is not grounding.** Verifying that output looks correct does not establish shared understanding. Epistemic acts function as grounding moves that verify alignment between user intent and AI interpretation.

6. **Scaffolding must fade.** Constant AI assistance at a fixed level is a crutch, not scaffolding. Across RDD cycles, the methodology should shift generative burden toward the user as expertise grows.

7. **Epistemic acts are bidirectional.** Each act simultaneously builds user understanding and enriches AI context for subsequent phases. This is not a side effect — it is a core mechanism. The compounding quality effect depends on both directions operating.

## Open Questions

- Should the product discovery artifact include a second example from a non-healthcare domain to demonstrate generality? (Reflection: 002, "The Healthcare Example")
- The "Mr. Market" product vs. "the research says" product framing is more precise than the essay's current formulation — should it be incorporated into the essay or the domain model as a named concept? (Reflection: 002, "'Mr. Market' Framing")
- How does the product discovery epistemic gate differ in practice from other gates, given that the user likely knows more about their users than the AI does? Does this invert the typical gate dynamic? (Essay 002, §10)
- How aligned should Product Vocabulary and Domain Model vocabulary be? Conway's law suggests system structure mirrors org structure — should system structure also mirror user mental models and access patterns? Deliberate divergence is fine; accidental divergence is product debt. The provenance column makes divergence visible, but should there be a formal alignment step between PRODUCT DISCOVERY and MODEL? (Epistemic gate conversation, 002)
- Inverse Conway problem: systems outlive the org structures that shaped them. When org structure changes but architecture doesn't follow, module boundaries become fossils of past assumptions. Should /rdd-product backward mode also audit for org-architecture drift (not just user-architecture misalignment)? What level of abstraction is resistant to higher-level change, and is that resilience a feature or a liability? (Epistemic gate conversation, 002)
- Backward mode scoping for legacy systems: when the existing system has conflicting encoded assumptions or poor documentation, the full five-section audit may surface an intractable product surface area. Should backward mode include an explicit triage step — identify the product surface that matters most, audit that first, flag the rest as known unknowns? Without scoping, backward mode risks producing a debt table too large to act on. (Epistemic gate conversation, DECIDE phase)
- External review loop: both primary documents (`product-discovery.md` for product stakeholders, `system-design.md` for technical stakeholders) are designed to be reviewed. When reviewers provide feedback, it must flow back through the pipeline — product feedback re-enters at PRODUCT DISCOVERY, technical feedback re-enters at ARCHITECT. The existing "go back to the relevant phase" pattern handles re-entry, but the trigger is external and potentially asynchronous. Should the orchestrator formalize external review as a pipeline operation? How does asynchronous input interact with the sequential phase model? How is re-propagation scope assessed — a minor correction vs. a fundamental challenge to the stakeholder map? **Confirmed as real workflow** — the team lead scoping use case includes sharing artifacts with architecture and product specialists before team handoff. (Epistemic gate conversation, ARCHITECT phase; product discovery dog-food, 2026-03-06)
- Should "scoping mode" (RESEARCH → ARCHITECT, no BUILD, with handoff to team) be elevated to a named workflow mode in the orchestrator, alongside Modes A-D? The team lead use case treats partial pipeline runs as first-class, not as "abbreviated Mode A." (Product discovery dog-food, 2026-03-06)
- How would Pair-RDD work mechanically at epistemic gates? The current pipeline has no affordance for multiple humans at a gate. Two collaborators responding together could recover the pair-programming dynamic lost in agentic coding and double the epistemic benefit. Worth its own research cycle. (Product discovery dog-food, 2026-03-06)
- Assumption inversions function as epistemic acts — they serve a dual purpose as both a critical design exercise (questioning product assumptions) and an instrument of knowledge advancement (building the user's understanding through the act of inversion). Should this dual relationship be formalized in the epistemic gate protocol, or is it sufficient that it emerges naturally during product discovery? User confirmation: "They all got me thinking, which is the point." (Product discovery dog-food, 2026-03-06)

## Amendment Log

| # | Date | Invariant | Change | Propagation |
|---|------|-----------|--------|-------------|
| 1 | 2026-03-05 | Invariant 0 | ADDED: outcome-level invariant establishing that the user must be able to explain what was built without AI assistance | Essay 001 §9 should reference this as the success criterion; all ADRs should trace back to it |
| 2 | 2026-03-05 | Concepts | ADDED: Maintenance Cliff, Context Window Ceiling. ADDED relationships: Opacity Problem manifests as Maintenance Cliff; Epistemic Gate prevents Maintenance Cliff; Context Window Ceiling necessitates human structural understanding | Informed by essay 001 §8 (requirements-only counterargument) |
| 3 | 2026-03-06 | Invariant 0 | STRENGTHENED: "what was built" → "what was built, who it was built for, and why." Added product dimension to the authority requirement | Essay 002 §11 proposed this amendment. Prior ADRs (001-005) predate this amendment but are not contradicted — they focus on epistemic gates, which serve the original scope. New ADRs should reference the strengthened invariant. Essay 001 abstract references Invariant 0 as "speak with authority about what was built" — needs supersession note or update |
| 4 | 2026-03-06 | Concepts | ADDED: Product Debt, Product Maintenance Cliff, Product Discovery, Stakeholder Map, User Mental Model, Value Tension, Assumption Inversion, Inversion Principle, Product Vocabulary, Product Conformance, Artifact Legibility. UPDATED: Phase (added PRODUCT DISCOVERY to list), Artifact (added product discovery document), Authority (added "who it was built for and why") | Informed by essay 002. New concepts establish product discovery vocabulary for downstream ADRs and skill design |
| 5 | 2026-03-06 | Relationships | ADDED: 14 new relationships covering Product Discovery feed-forward (into MODEL, DECIDE, ARCHITECT), Product Debt dynamics, Inversion Principle cross-cutting scope, Product Conformance complementing Technical Conformance | Informed by essay 002 §§7-8 |
| 6 | 2026-03-06 | Concepts, Relationships, Open Questions | ADDED concepts: Scoping, Pair-RDD, Research-Engineer, Handoff, External Review. ADDED 7 relationships for new concepts. ADDED 3 open questions (scoping mode, pair-RDD mechanics, assumption inversions as epistemic acts). UPDATED external review open question to note confirmed as real workflow. | Informed by product discovery dog-food (backward mode on RDD itself) |
