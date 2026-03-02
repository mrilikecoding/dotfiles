# Design: RDD Architect Phase & Build Stewardship Checkpoints

*2026-03-02*

## Problem

The RDD pipeline (research → model → decide → build) produces strong research artifacts but lacks architectural design thinking. The decide phase makes individual decisions (ADRs), and the build phase implements scenarios via TDD — but nobody composes those decisions into a coherent system architecture before coding begins. The result: responsibility accumulates in whatever class first needs it, producing god-classes that require later decomposition.

Additionally, the build phase has no reflexive mechanism for evaluating structural health during implementation. Each TDD step is locally correct but globally accumulating debt.

Finally, as artifact sets grow (dozens of essays and ADRs), context becomes too large. Build needs a compiled rollup, not the full artifact history.

## Solution

Two additions to the RDD pipeline:

1. **`rdd-architect`** — a new phase between decide and build that produces a System Design document
2. **Stewardship checkpoints** — a two-tier reflexive mechanism in build that catches architectural drift

## The Full Pipeline

```
research → model → decide → architect → build (with checkpoints)
```

### Artifact flow

| Phase | Reads | Produces |
|-------|-------|----------|
| research | (user's question) | essay, research log |
| model | essay | domain model (concepts, actions, relationships, invariants) |
| decide | domain model (invariants first), essay, prior ADRs | ADRs, scenarios, conformance debt, argument audit |
| **architect** | domain model, ADRs, scenarios, essay | **system design** (modules, responsibilities, dependencies, fitness criteria, provenance) |
| build | **system design** (primary), domain model (invariants only), scenarios | working code, design amendments |

**Key change:** Build reads the system design as its primary context, not the full artifact set. The system design is the compiled rollup. Build reaches back to upstream artifacts only when challenging a constraint.

---

## Part 1: The `rdd-architect` Phase

### Input artifacts

- Domain model (`./docs/domain-model.md`) — concepts, actions, relationships, invariants
- ADRs (`./docs/decisions/`) — technology and structural decisions
- Scenarios (`./docs/scenarios.md`) — behavior specifications
- Essay (`./docs/essays/`) — research context

### Output artifact

System Design Document (`./docs/system-design.md`)

### Process

**Step 1: Read all prior artifacts.** Invariants first, as with all RDD phases.

**Step 2: Identify architectural drivers.** Extract from ADRs and essay:
- Quality attribute priorities (what does this system optimize for?)
- Key constraints (technology choices, platform requirements)
- Scale expectations
- Integration boundaries (external systems, APIs)

**Step 3: Module decomposition.** Propose modules/components, each with:
- A name drawn from domain vocabulary
- A 1-sentence purpose (if you can't say it in one sentence, it's too broad)
- Clear boundary: what's inside, what's outside

**Step 4: Responsibility allocation.** Build a matrix mapping every domain concept and action from the glossary to exactly one owning module. This is the key artifact — it prevents god-classes by allocating responsibility before code is written. If a concept or action doesn't have a clear home, that's a design tension to resolve now.

**Step 5: Dependency graph.** Define directed dependencies between modules:
- Dependencies point in one direction (no cycles)
- Inner/core modules don't depend on outer/infrastructure modules
- Identify any module everything depends on — is it stable enough?

**Step 6: Integration contracts.** For each module boundary, specify how modules communicate: function calls, events, shared types, etc.

**Step 7: Architectural fitness criteria.** Define measurable properties:
- Max responsibilities per module (tied to the responsibility matrix)
- Dependency direction rules
- Coupling constraints
- Domain-specific fitness criteria from invariants

**Step 8: Design audit.** Evaluate:
- Does the design honor all invariants?
- Does the responsibility allocation cover all domain concepts/actions?
- Are there modules with suspiciously many or few responsibilities?
- Does the dependency graph have cycles?
- Do the ADRs' consequences align with the module structure?

**Step 9: Present for approval.** Highlight:
- Modules that were hard to scope (potential design tensions)
- Concepts that could live in multiple modules (judgment calls)
- Fitness criteria that will be enforced during build

### Retrofit Mode (Adopting Mid-Stream)

When introducing rdd-architect to an existing codebase — whether it has prior RDD artifacts or not:

**Step R1: Architectural reconnaissance.** Scan the codebase to understand what exists: modules, dependencies, responsibility distribution, patterns in use. Produces an "as-built" picture.

**Step R2: Artifact reconciliation.** If prior RDD artifacts exist:
- Map domain model concepts/actions to where they *actually* live in code
- Check which ADR decisions are reflected in code vs. aspirational or violated
- Produce a gap analysis: as-built vs. as-intended

If no prior artifacts exist, the as-built picture is the starting point.

**Step R3: Produce the system design.** Write the document describing:
- Current state — modules as they exist, responsibilities as currently allocated
- Conformance debt — where current state diverges from intentions
- Provenance — link to existing artifacts where possible; mark unlinked items as "emerged" or "accidental"

**Step R4: Triage.** Present to the user: actual architecture vs. intended. User decides:
- Which divergences are bugs vs. the ADRs being wrong
- Whether the current structure is worth preserving or needs redesign
- What the target system design should look like

---

## Part 2: Provenance Model

Every entry in the system design carries a provenance annotation linking it back through the artifact chain.

### Provenance chain

```
code → system design → invariants/ADRs → essays/research
```

### Format in the system design

```markdown
### Module: ExtractionPipeline
**Purpose:** Orchestrates multi-stage extraction of semantic content.
**Provenance:** Invariant I-3; ADR-005; Essay §3.2

**Owns:** extract, transform, validate (actions); Pipeline, Stage, ExtractResult (concepts)
**Depends on:** ContentModel, StorageAdapter
**Depended on by:** CLI, API
```

### "Can I change this?" decision tree

During build, when a constraint feels wrong:

```
Follow the provenance chain:
├─ Traces to a researched invariant with strong evidence?
│   └─ Load-bearing. Revisit /rdd-research to challenge it.
├─ Traces to an ADR judgment call?
│   └─ Changeable. Propose a Design Amendment with superseding rationale.
├─ Traces to a design-phase allocation (no deeper root)?
│   └─ Freely changeable. Propose a Design Amendment.
└─ No provenance?
    └─ Accidental. Change freely, add provenance to prevent future confusion.
```

---

## Part 3: Design Versioning

The system design is a living document. Changes are tracked explicitly.

### Status header

The document opens with a version/status block:

```markdown
**Version:** 1.0
**Status:** Current
**Last amended:** 2026-03-02
```

### Design Amendments

When build discovers something needs to change in the design:

1. A Design Amendment is proposed — written as a clearly marked proposed change
2. The amendment includes provenance: what triggered it (scenario, finding, new information)
3. User reviews and approves or rejects
4. If approved, amendment is applied and logged

### Design Amendment Log

```markdown
| # | Date | What Changed | Trigger | Provenance | Status |
|---|------|-------------|---------|------------|--------|
| 1 | 2026-03-05 | Split ExtractionPipeline into Extractor + Transformer | Tier 2 review: responsibility accumulation after scenarios 8-12 | ADR-005 still holds; I-3 satisfied by Extractor alone | Accepted |
```

---

## Part 4: Stewardship Checkpoints in Build

### When they trigger

At natural scenario boundaries — completing a logical group of scenarios that forms a coherent feature or crosses a component boundary. The builder identifies these boundaries.

### Tier 1: Lightweight Stewardship Check

A quick structural scan after each scenario group:

1. **Responsibility conformance** — count responsibilities per module against the system design. Flag accumulation outside the allocation.
2. **Dependency direction** — check imports against the design's dependency graph. Flag violations.
3. **Cohesion check** — is new code landing in the module the design assigns? Or gravitating to a "convenient" module?
4. **Size signal** — is any file or class growing disproportionately?
5. **Fitness criteria** — check against measurable properties from the system design.

If all clear → continue. If flags → fix with tidying or escalate.

### Tier 2: Deep Architecture Review (Escalation)

Triggered when Tier 1 flags can't be resolved with simple tidying. Borrows from the codebase-audit's meso-level analysis:

- **Coupling analysis** — actual dependencies vs. designed dependencies
- **Intent-implementation alignment** — are modules doing what the design says?
- **Invariant enforcement** — are invariants enforced where the design says?

Produces findings in stewardship format (observation, pattern, tradeoff, question, recommendation). If findings reveal the *design* was wrong, triggers a Design Amendment.

### The Reflexive Loop

```
build scenario group
  → Tier 1 check
    → clean? → continue
    → flag? → can fix with tidying? → tidy, continue
             → structural issue? → Tier 2 deep review
               → code problem? → fix code
               → design problem? → Design Amendment → user approval → update design → continue
```

---

## What This Does NOT Change

- **research** — unchanged
- **model** — unchanged
- **decide** — unchanged (ADRs, scenarios, argument audit, conformance audit all stay as-is)
- **build's TDD loop** — unchanged (still BDD outer loop, TDD inner loop, structure-vs-behavior separation)

The additions are purely additive: a new phase, provenance in the system design, and checkpoints in build.
