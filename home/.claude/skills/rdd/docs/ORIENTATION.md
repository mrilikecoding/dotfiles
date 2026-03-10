# Orientation: Research-Driven Development (RDD)

*Generated 2026-03-10*

## What This System Is

RDD is a methodology for building software through structured understanding. It replaces the common pattern of AI-generates-everything with a phased pipeline — research, product discovery, domain modeling, decisions, architecture, build — where the AI generates artifacts and the human engages with them at epistemic gates before proceeding. The central bet: if the person who runs the pipeline can explain what was built, who it was built for, and why, the software will be better and more maintainable than if they simply approved AI output.

## Who It Serves

- **Solo Developer-Researcher** — runs the full pipeline to understand before building. The primary user.
- **Research-Engineer-Writer** — uses the research, product discovery, and modeling phases as a structured investigation methodology, whether or not software gets built.
- **Team Lead (scoping)** — runs RESEARCH through ARCHITECT, then hands off artifacts to a team for building. Uses RDD as a leadership thinking tool.
- **AI Agent** — executes the skill files. The pipeline's instructions are literally written for this stakeholder.
- **Teammates / Collaborators** — receive artifacts without having gone through the gates. Need this document to orient.

## Key Constraints

1. **The user must be able to speak with authority** about what was built, who it was built for, and why — without AI assistance. Every other design decision serves this outcome. (Invariant 0)
2. **Understanding requires generation, not review.** Every gate requires the user to produce something — an explanation, prediction, or articulation. Approval alone is not sufficient. (Invariants 1, 2)
3. **Pragmatic actions may be automated; epistemic actions may not.** The boundary between what the AI does and what the human does is the core design decision. (Invariant 3)
4. **Epistemic cost must remain lightweight.** 5-10 minutes per gate. If it becomes burdensome, users will circumvent it. (Invariant 4)

## How the Artifacts Fit Together

**Tier 1 — Entry Point (this document)**
- `ORIENTATION.md` — system overview, routes readers to depth

**Tier 2 — Primary Readables (read end-to-end)**
- `product-discovery.md` — stakeholder maps, jobs, value tensions, assumption inversions. Written in user language. The product perspective.
- `system-design.md` — module decomposition, responsibility allocation, dependency graph, provenance chains. The technical perspective.

**Tier 3 — Supporting Material (consulted for provenance and depth)**
- `domain-model.md` — concepts, actions, relationships, invariants. The vocabulary authority.
- `essays/` — research findings (4 essays: pedagogical epistemology, product discovery, synthesis, orientation document)
- `decisions/` — ADRs (21 decisions, from epistemic gates through orientation document)
- `scenarios.md` — refutable behavior specifications (95 scenarios)
- `essays/reflections/` — meta-observations from epistemic gate conversations
- `essays/research-logs/` — process records from research phases

## Current State

**Pipeline:** All phases have been designed and built. The pipeline runs: RESEARCH → PRODUCT DISCOVERY → MODEL → DECIDE → ARCHITECT → BUILD → SYNTHESIS (optional).

**What's settled:**
- Epistemic gate protocol (ADRs 001-005) — implemented in all skill files
- Product discovery phase (ADRs 006-011) — implemented as `/rdd-product`
- Synthesis phase (ADRs 012-018) — implemented as `/rdd-synthesis`
- Orientation document (ADRs 019-021) — integrated into orchestrator
- Three-tier artifact hierarchy replacing prior two-tier model

**Open questions (selected):**
- Should "scoping mode" (RESEARCH → ARCHITECT with handoff) be a named workflow mode?
- How would Pair-RDD work at epistemic gates?
- Should external review be formalized as a pipeline operation?
- Cross-project synthesis (portfolio mode) is described but not operationalized
- Fading implementation (Invariant 6) is deferred — tracked as design debt (ADR-005)
