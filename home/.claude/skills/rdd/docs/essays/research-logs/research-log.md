# Research Log: RDD Artifact Gap — Sequencing, Field Guide, and Document Sizing

## Question 1: What document types fill the gap between architecture specification and implementation approach — and how do they serve both "how to sequence the work" and "how to understand the system deeply enough to own it"?

**Method:** Web search across architecture documentation frameworks (TOGAF, arc42, C4, Diátaxis), software mental model research, and developer onboarding/handoff patterns.

**Findings:**

### The Roadmap/Strategy Document

TOGAF makes a clean distinction between an **Architecture Roadmap** (Phase E) and an **Implementation and Migration Plan** (Phase F). The roadmap is strategic — "the definition, but not the activities." It contains:

- **Work packages** — logical groups of changes with dependencies, objectives, and business value
- **Transition architectures** — intermediate states between current and target
- **A consolidated gaps/solutions/dependencies matrix** — what needs to happen before what, and why
- **NOT:** detailed task lists, timelines, resource allocation, or how to execute each piece

The TOGAF Standard explicitly states: "The Architecture Roadmap supports decisions about your path, destination, and where decisions have not been made." It is a tool for informed sequencing, not prescribed sequencing.

Arc42's **Section 4 (Solution Strategy)** occupies similar territory at a smaller scale: "a short summary and explanation of the fundamental decisions and solution strategies that shape the system's architecture." The guidance: "Keep the explanation of these key decisions short" while motivating choices. These decisions "form the cornerstones for your architecture — they are the basis for many other detailed decisions or implementation rules."

Both frameworks distinguish between *enabling informed decisions about sequencing* and *dictating the sequence*. The roadmap gives the builder enough context to make good sequencing decisions on their own.

### The Field Guide / Understanding Document

Diátaxis classifies documentation into four types. The field guide concept maps to **explanation** — "understanding-oriented" documentation that takes "a higher and wider" perspective than reference or how-to material. Key characteristics from Diátaxis:

- Answers "Can you tell me about…?" not "How do I…?"
- Helps readers "weave disparate knowledge into cohesive understanding"
- "Illuminates the subject by taking multiple different perspectives on it"
- Admits opinion and perspective, weighing alternatives
- Keeps tight boundaries — no instruction or specification that belongs elsewhere

Jennifer Moore's work on mental maps argues that **mental models cannot be documented** — "it's more or less impossible to document the models we build in ways others can recreate." But documentation *can scaffold the building of mental maps*. The field guide doesn't contain understanding; it enables the reader to build their own through exploration. Moore: "Discussion can help quite a bit because people within the system respond to your questions and assumptions."

Simon Brown (C4): "The code is the truth, but not the whole truth." Architecture documentation describes what code alone cannot convey — context, rationale, deployment, stakeholders. The **Software Guidebook** concept covers: functional overview, quality attributes, constraints, external interfaces, and decision log — enough to understand *why* the system is the way it is.

Research on developer mental models shows a hierarchical understanding flow: global overview → module-level understanding → detailed implementation. Novices build bottom-up (line-by-line assembly); experts abstract over patterns and anticipate interactions. A field guide should support both paths.

### How These Relate to Existing RDD Artifacts

The current RDD artifact hierarchy:

- **ORIENTATION.md** (Tier 1) — routes readers to the right document. "What is this, who's it for, where do I go?"
- **product-discovery.md** (Tier 2) — stakeholder perspective. "Who is this for and why?"
- **system-design.md** (Tier 2) — technical specification. "What are the modules, responsibilities, contracts?"
- **Tier 3** — domain model, ADRs, scenarios, essays (depth and provenance)

The gap: none of these documents answer:
1. "What's the strategic shape of the work remaining?" (roadmap)
2. "How does the designed system relate to what's actually built, and what do I need to understand to own it?" (field guide)

The system-design.md already has a **Build Sequence** section (Phases 0-3), but it's embedded in the architecture document and reads as prescriptive build instructions — not a tool for informed sequencing decisions. Moving this concern to its own artifact would let it serve a different purpose: enabling the builder to make their own sequencing choices.

**Implications:**

Two new document types emerge, each with a distinct function:

1. **Roadmap** (working title) — TOGAF-style architecture roadmap adapted to RDD. Contains work packages with dependencies and transition states. Enables sequencing decisions without dictating them. Sits alongside system-design.md as a Tier 2 artifact (or between Tier 2 and Tier 3). Updated reflexively when architecture changes.

2. **Field Guide** (working title) — Diátaxis "explanation" document that maps the system design's desired state to what actually exists. Scaffolds mental model building for developers who need to own the system. Lives in references (per user). Updated reflexively like other core docs. Connects domain concepts to code structures, surfaces the "why" behind structural choices, and points to where to explore.

Both serve Invariant 0 from different angles: the roadmap helps the builder understand *what work means* well enough to sequence it themselves. The field guide helps the builder understand *what the system is* well enough to speak about it with authority.

## Question 2: What does research say about optimal document length for human comprehension and agent context windows — and what heuristics should govern when a document breaks into subfiles?

**Method:** Web search across cognitive load theory (Cowan, Miller, Sweller), reading comprehension research, LLM context window research ("lost in the middle"), documentation framework guidance (Diátaxis, arc42, Every Page is Page One), and Anthropic's context engineering recommendations.

**Findings:**

### Human Working Memory

Cowan (2010) refines Miller's famous 7±2 to a more accurate **3-5 meaningful items (chunks)** in working memory for young adults. Key findings:

- When rehearsal and grouping strategies are controlled for, the underlying storage capacity is ~4 items, not 7
- Chunking doesn't increase the limit — it redefines what counts as one unit. A chunk can be a single word or a learned association, but the number of concurrent chunks stays constant at 3-5
- Duration is also constrained: 5-9 information elements can be held for no more than ~20 seconds, fewer when elements must be combined or manipulated

**Implication for documents:** A section that requires the reader to hold more than 3-5 concepts simultaneously to understand it exceeds working memory. Sections should be designed so each one introduces or builds on a small number of concepts that can be chunked together before the next section adds more.

### Reading Comprehension and Document Length

Research findings on document length and reading:

- Paragraph length alone did not have a statistically significant effect on comprehension scores — structure and readability matter more than raw length
- The **reading contract** concept (Tom Johnson, I'd Rather Be Writing): readers trade time for task completion. Task-oriented docs succeed because the payoff is clear. Conceptual/explanation docs lack this urgency — a 20+ page workflow narrative received only 1 survey response from 8 recipients
- Long, high-level conceptual docs don't command the same reading attention as task-based docs
- Strategies for long docs: aggressive shortening (500 words vs 3,000), progressive disclosure, task integration, interactivity

**Implication:** Document length matters less than *purpose clarity* and *cognitive chunking*. A 7,000-word document is fine if it's reference material consulted in sections. The same 7,000 words as a conceptual narrative will lose most readers.

### LLM Context Window Utilization

The "lost in the middle" problem (Stanford/UW, 2023) is well-documented and persists in 2026:

- LLMs exhibit a **U-shaped performance curve**: better recall at beginning and end, significant degradation in the middle of long contexts
- Accuracy drops from ~75% to 55-60% for information positioned in the middle at 4K tokens
- Even models advertising 1M-token windows show **effective context capping at 30-60%** of stated capacity before recall decay
- Gemini 1.5 maintains recall up to 1M tokens but average recall hovers around 60% — 40% of context facts are effectively lost

**Anthropic's context engineering guidance** (from their engineering blog):
- "The smallest set of high-signal tokens that maximize the likelihood of your desired outcome"
- Maintain "lightweight identifiers" (file paths, queries, links) and load data just-in-time rather than pre-loading everything
- Sub-agent architectures return condensed summaries of **1,000-2,000 tokens**
- Start with minimal prompts, add instructions based on actual failure modes
- Optimize ruthlessly for relevance, not comprehensiveness

**RAG chunking research** finds optimal chunk sizes of **256-512 tokens for factual retrieval**, **512-1024 tokens for analytical content**. Documents should align chunks with natural boundaries (paragraph breaks, section headers, topic transitions).

### Documentation Framework Guidance on Granularity

**Every Page is Page One** (Mark Baker): Topics should be self-contained, specific-purpose, and "function alone." No linear dependencies — no previous/next, no parent/child. Each topic establishes its own context. This is the strongest argument for splitting: **when a document has multiple distinct purposes, it should be multiple documents.**

**Arc42:** "Pretty minimalistic... keeps documentation relatively slim." Every section is optional. Emphasizes pragmatism over prescribed lengths.

**Diátaxis:** Implicitly argues for splitting by type — tutorials, how-to guides, reference, and explanation serve different reader needs and should not be combined in one document.

### Current RDD Document Sizes (for reference)

| Document | Lines | Words | Approximate Tokens |
|----------|-------|-------|-------------------|
| ORIENTATION.md | 80 | 712 | ~950 |
| product-discovery.md | 142 | 2,941 | ~3,900 |
| SKILL.md (orchestrator) | — | 3,117 | ~4,150 |
| scenarios.md | 648 | 5,499 | ~7,300 |
| domain-model.md | 240 | 6,832 | ~9,100 |
| system-design.md | 504 | 6,969 | ~9,300 |

The two largest documents (domain-model.md and system-design.md) are both approaching ~9,000 tokens. Given the lost-in-the-middle problem, an agent reading system-design.md will reliably process the beginning (architectural drivers) and end (design amendment log) but may miss details in the middle (responsibility matrix, integration contracts).

**Implications:**

A set of heuristics emerges from converging evidence across cognitive science, reading research, LLM performance, and documentation practice:

**Heuristic 1: The Purpose Test (from Every Page is Page One).** A document should serve one purpose for one audience. When a document serves multiple distinct purposes or audiences, split it. The system-design.md currently serves as architectural specification AND responsibility reference AND integration contract reference AND test architecture AND build sequence — at least five distinct purposes. This is the strongest signal for splitting.

**Heuristic 2: The 3-5 Concept Rule (from Cowan).** Each section should require the reader to hold no more than 3-5 concepts simultaneously. Sections that exceed this should be restructured — either by chunking concepts into prerequisite groups or by splitting into sub-documents with explicit cross-references.

**Heuristic 3: The ~5,000 Word / ~6,500 Token Ceiling (from LLM research).** Documents that an agent must read end-to-end and act on should stay under ~5,000 words (~6,500 tokens). This keeps the full document within the zone where LLM recall remains high (before the middle-of-context degradation sets in significantly). Documents above this threshold should either be split into sub-documents or designed for section-level consultation rather than end-to-end reading.

**Heuristic 4: The Read Contract (from reading research).** Reference material (consulted in sections) can be longer than narrative material (read end-to-end). A 9,000-token domain model consulted by glossary lookup is fine. A 9,000-token system design read narratively is not. If the document is meant to be read end-to-end, it should be shorter or restructured for section-level access.

**Heuristic 5: Position-Sensitive Placement (from lost-in-the-middle).** In documents agents will consume, place the most critical information at the beginning and end. Bury nothing important in the middle third. For very long documents, use explicit section headers and structural markers that help both humans and agents navigate.

These heuristics cascade: first apply the Purpose Test (should this be one document at all?), then the Concept Rule (are sections cognitively manageable?), then the Token Ceiling (is the whole document within effective processing range?), then the Read Contract (is length appropriate for the document's access pattern?), then Position-Sensitive Placement (is critical information well-positioned?).

## Question 3: Does RDD need a conformance audit skill that systematically brings project documentation into alignment when the RDD skill set evolves or when RDD is added to an existing project?

**Method:** Web search across architecture conformance review practices (TOGAF compliance reviews, architectural drift detection), documentation migration patterns, and review of RDD's existing audit/backward-propagation mechanisms.

**Findings:**

### The Conformance Problem in Two Scenarios

Two scenarios produce the same structural problem — a mismatch between what RDD's skill files expect and what the project's artifact corpus contains:

1. **RDD skill evolution.** When the RDD skills themselves are updated (e.g., new artifact types like the roadmap and field guide, new document sections, amended template structures), existing projects that ran prior cycles have artifacts shaped by the old skill version. A project that ran through ARCHITECT before the orientation document was added has no ORIENTATION.md. A project that ran before product discovery was a phase has no product-discovery.md.

2. **Adding RDD to an existing project.** When a developer applies RDD to a project that already has code, architecture docs, or domain knowledge, the existing artifacts don't conform to RDD's expected structure. This is distinct from backward mode (which audits product assumptions) — it is a *format conformance* problem, not a *content* problem.

### How TOGAF Handles Conformance

TOGAF defines a formal Architecture Compliance Review with six conformance levels: Irrelevant (no features in common), Consistent (some features match), Compliant (all implemented features covered), Conformant (all spec features implemented plus extras), Fully Conformant (full correspondence), and Non-Conformant (some features don't match). The review uses checklists tailored to the project.

The key insight from TOGAF: conformance is a spectrum, not a binary. A project can be *partially conformant* — some artifacts match the current schema, others need updating. The audit's job is to identify the gaps and prioritize them, not to treat every gap as equally urgent.

### Architectural Drift Research

Research on architectural drift (Koschke et al., 2023) defines the problem as "the diverging of the implemented code from the architecture design of the system." The same concept applies to documentation: the divergence between the RDD skill files' expected artifact structure and the actual artifact corpus is *documentation drift*.

Automated detection approaches use a model-driven pattern: define the expected structure as a specification, analyze the actual artifacts, reconstruct their structure, and compare against the spec. This is directly applicable — the RDD skill files define expected artifact templates; the project's docs directory contains the actual artifacts; the gap between them is the drift.

### What RDD Already Has

RDD has several mechanisms that partially address conformance:

- **Backward propagation** — when an invariant changes, all prior documents are swept for contradictions. But this is invariant-scoped, not format-scoped.
- **Product conformance audit** — `/rdd-product` backward mode audits product assumptions against user needs. But this is content-scoped, not template-scoped.
- **Stewardship checkpoints** in BUILD verify architectural conformance at scenario boundaries. But this is code-scoped.
- **ORIENTATION.md regeneration** at milestones catches some drift (regeneration reads the full corpus). But this is a single artifact, not a corpus-wide sweep.

None of these mechanisms address the specific problem of *template/format conformance across the entire artifact corpus* when the skill set itself evolves.

### What an RDD Conformance Audit Would Do

An audit skill (working title: `/rdd-audit` or `/rdd-conform`) would:

1. **Read the current RDD skill version** — extract expected artifact templates, required sections, naming conventions, and inter-artifact references from each SKILL.md
2. **Scan the project's artifact corpus** — identify which artifacts exist, what sections they contain, and how they reference each other
3. **Produce a conformance report** — gap analysis with TOGAF-style conformance levels per artifact:
   - Which artifacts are missing entirely (e.g., no roadmap, no field guide, no ORIENTATION.md)
   - Which artifacts exist but are missing required sections (e.g., product-discovery.md lacks an Assumption Inversions section)
   - Which artifacts have sections that don't match current templates (e.g., domain model missing the Product Origin column)
   - Which inter-artifact references are broken (e.g., system design references a Build Sequence that has been moved to the roadmap)
4. **Prioritize the gaps** — distinguish between structural gaps (missing artifacts that downstream phases depend on) and format gaps (sections that could be updated but don't block anything)
5. **Offer remediation** — either generate missing artifacts/sections (pragmatic action, Invariant 3) or flag them for the user to address at the next relevant phase

This is distinct from re-running the full pipeline. The audit does not produce new research, new product discovery, or new decisions. It brings the *format* of existing artifacts into alignment with the current skill version, preserving the *content* that was produced by prior cycles.

**Implications:**

The conformance audit addresses three real workflow pain points:

1. **Skill evolution maintenance.** When the RDD skills gain new artifact types or template changes, existing projects need a way to identify and close the gaps without re-running entire cycles. The audit provides a targeted, prioritized path.

2. **RDD adoption for existing projects.** When adding RDD to a project that already has artifacts, the audit identifies what needs to be created, what can be adapted, and what is already conformant — a structured onboarding ramp rather than starting from scratch.

3. **Post-build drift.** When RDD produces artifacts through ARCHITECT and someone builds without using `/rdd-build` (or builds beyond scenario coverage), the code moves but the docs don't. The next RDD cycle re-enters with an artifact corpus that describes a system that no longer matches reality. This is likely the most common case in practice — and the most dangerous, because stale docs create a false foundation for downstream phases.

The audit is a pragmatic action (Invariant 3): the agent performs the scan and produces the report, the user decides which gaps to address. It does not require an epistemic gate — the conformance report is informational, not a learning instrument. However, the third case (post-build drift) raises an interesting question: if the docs are stale enough that the user's understanding no longer matches reality, is updating the docs sufficient, or should the relevant phase be re-run with its epistemic gate to rebuild understanding? The conformance audit can flag the gap; the decision about pragmatic update vs. epistemic re-engagement belongs to the user.

A fourth operation emerged from the epistemic gate conversation: **graduation** — rolling up what RDD produced into the project's native documentation and archiving the RDD-specific artifacts. This serves the case where RDD was used to get something off the ground but the project has moved to a different workflow. Graduation extracts durable knowledge (decisions, vocabulary, product context, rationale) into the project's native format and archives the RDD artifacts as historical record. RDD's docs served as scaffolding; once the building stands, the scaffolding can come down. The project retains the knowledge without maintaining a parallel documentation system. This connects to Invariant 6 (scaffolding must fade) — applied not to the epistemic gates within a cycle, but to the methodology's artifact structure across the project's lifecycle.
