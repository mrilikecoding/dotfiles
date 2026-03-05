# System Design: Pedagogical RDD — Epistemic Gates

**Version:** 1.0
**Status:** Current
**Last amended:** 2026-03-05

## Architectural Drivers

| Driver | Type | Provenance |
|--------|------|------------|
| Every gate must require user generation, not just approval | Quality Attribute | Invariant 1, 2; ADR-001 |
| Epistemic cost stays under 5-10 min per gate | Constraint | Invariant 4; ADR-003 |
| Each skill is self-contained (owns its gate definition) | Quality Attribute | ADR-002 |
| User responses enrich subsequent phases | Quality Attribute | Invariant 7; ADR-004 |
| Prompts reference specific artifact content, not generic questions | Quality Attribute | ADR-003 |
| Prompts use exploratory framing, not quiz framing | Quality Attribute | ADR-003 |
| Structural generation requirement never fades | Constraint | Invariant 2; ADR-005 |
| System is prompt text in markdown files | Platform Constraint | Context |

## Module Decomposition

### Module: Orchestrator (`rdd/SKILL.md`)
**Purpose:** Defines the epistemic gate protocol and ensures no phase transition consists solely of approval.
**Provenance:** ADR-001 (gate pattern); ADR-002 (orchestrator defines protocol); ADR-004 (feed-forward instruction); Invariant 2
**Owns:** Gate protocol definition, pipeline sequence, state tracking, feed-forward instruction
**Depends on:** None (top-level coordinator)
**Depended on by:** All phase skills (they follow its protocol)

### Module: Research Skill (`rdd-research/SKILL.md`)
**Purpose:** Adds an epistemic gate section with exploratory prompts tailored to essay artifacts.
**Provenance:** ADR-002 (skill owns gate); ADR-003 (research gate assignments); Essay §6
**Owns:** Research-phase epistemic gate prompts, essay presentation step
**Depends on:** Orchestrator (protocol)
**Depended on by:** None directly (produces essay artifact consumed by Model Skill via file)

### Module: Model Skill (`rdd-model/SKILL.md`)
**Purpose:** Adds an epistemic gate section with exploratory prompts tailored to domain model artifacts.
**Provenance:** ADR-002; ADR-003 (model gate assignments); Essay §6
**Owns:** Model-phase epistemic gate prompts, domain model presentation step
**Depends on:** Orchestrator (protocol)
**Depended on by:** None directly (produces domain model artifact consumed by Decide Skill via file)

### Module: Decide Skill (`rdd-decide/SKILL.md`)
**Purpose:** Adds an epistemic gate section with exploratory prompts tailored to ADR and scenario artifacts.
**Provenance:** ADR-002; ADR-003 (decide gate assignments); Essay §6
**Owns:** Decide-phase epistemic gate prompts, ADR/scenario presentation step
**Depends on:** Orchestrator (protocol)
**Depended on by:** None directly (produces ADR + scenario artifacts consumed by Architect Skill via file)

### Module: Architect Skill (`rdd-architect/SKILL.md`)
**Purpose:** Adds an epistemic gate section with exploratory prompts tailored to system design artifacts.
**Provenance:** ADR-002; ADR-003 (architect gate assignments); Essay §6
**Owns:** Architect-phase epistemic gate prompts, system design presentation step
**Depends on:** Orchestrator (protocol)
**Depended on by:** None directly (produces system design artifact consumed by Build Skill via file)

### Module: Build Skill (`rdd-build/SKILL.md`)
**Purpose:** Adds epistemic prompts to the scenario completion step for reflection-in-action and self-explanation.
**Provenance:** ADR-002; ADR-003 (build gate assignments); Essay §6
**Owns:** Build-phase epistemic gate prompts, scenario completion presentation step
**Depends on:** Orchestrator (protocol)
**Depended on by:** None

## Responsibility Matrix

| Domain Concept/Action | Owning Module | Provenance |
|----------------------|---------------|------------|
| Gate (protocol definition) | Orchestrator | ADR-001, ADR-002 |
| Epistemic Gate (protocol) | Orchestrator | ADR-001, Invariant 2 |
| Approval Gate (removal) | Orchestrator + all skills | ADR-001 |
| Epistemic Act (framework) | ADR-003 (reference); each skill (implementation) | ADR-002, ADR-003 |
| Self-Explanation (prompts) | Research Skill, Model Skill, Build Skill | ADR-003 |
| Elaborative Interrogation (prompts) | Decide Skill | ADR-003 |
| Retrieval Practice (prompts) | Model Skill, Architect Skill | ADR-003 |
| Articulation (prompts) | Research Skill, Decide Skill, Architect Skill | ADR-003 |
| Reflection (prompts) | Research Skill, Decide Skill, Architect Skill, Build Skill | ADR-003 |
| Metacognitive Prompt | Each skill (in its gate section) | ADR-003, Invariant 2 |
| Grounding Move | Each skill (epistemic acts function as) | Invariant 5, ADR-001 |
| Common Ground (enrichment) | Orchestrator (feed-forward instruction) | ADR-004, Invariant 7 |
| Tacit Knowledge (surfacing) | Each skill (side effect of epistemic acts) | Essay §7 |
| Fading (deferred) | None — tracked as design debt | ADR-005 |
| Scaffolding | Each skill (fixed-level prompts) | ADR-005 |
| Authority (building) | Pipeline-wide (cumulative effect) | Invariant 0 |
| Pipeline (sequence) | Orchestrator | Existing design |
| Phase (definition) | Each skill | Existing design |
| Artifact (production) | Each skill | Existing design |
| Epistemic Artifact (dual role) | Each skill (gate transforms artifact into learning instrument) | Essay §6 |
| Generate (action) | Each skill (unchanged — AI still generates) | ADR-001 |
| Approve (action — being replaced) | Orchestrator + all skills | ADR-001 |
| Self-Explain (action) | Research, Model, Build skills | ADR-003 |
| Interrogate (action) | Decide Skill | ADR-003 |
| Retrieve (action) | Model, Architect skills | ADR-003 |
| Articulate (action) | Research, Decide, Architect skills | ADR-003 |
| Reflect (action) | Research, Decide, Architect, Build skills | ADR-003 |
| Ground (action) | Orchestrator (protocol); each skill (execution) | ADR-001, ADR-004 |
| Surface (action) | Each skill (side effect of epistemic acts) | Essay §7 |
| Fade (action — deferred) | None | ADR-005 |
| Opacity Problem | Essay (motivating context — not implemented in code) | Essay §1 |
| Metacognitive Illusion | Essay (motivating context) | Essay §1 |
| Maintenance Cliff | Essay (motivating context) | Essay §8 |
| Context Window Ceiling | Essay (motivating context) | Essay §8 |
| Desirable Difficulty | Essay (theoretical basis) | Essay §2 |
| Cognitive Level | Essay (theoretical basis) | Essay §2 |
| Dreyfus Stage | Essay (theoretical basis — informs future fading) | Essay §2 |

## Dependency Graph

```
Orchestrator
├── Research Skill
├── Model Skill
├── Decide Skill
├── Architect Skill
└── Build Skill
```

**Edges (all directed from Orchestrator to skills):**
- Orchestrator → Research Skill (invokes, defines protocol)
- Orchestrator → Model Skill (invokes, defines protocol)
- Orchestrator → Decide Skill (invokes, defines protocol)
- Orchestrator → Architect Skill (invokes, defines protocol)
- Orchestrator → Build Skill (invokes, defines protocol)

**Inter-skill communication:** Skills do not depend on each other directly. They communicate through artifact files (essay → domain model → ADRs → system design → code). This is an existing pattern that does not change.

**Layering rules:**
- Orchestrator is the outer layer (coordination)
- Skills are the inner layer (phase execution)
- Skills never reference the orchestrator's content — they follow its protocol implicitly
- No cycles exist

## Integration Contracts

### Orchestrator → Each Phase Skill
**Protocol:** The orchestrator invokes each skill via `/skill-name`. The skill runs its phase, produces an artifact, and presents it at its epistemic gate. The orchestrator resumes after the gate completes.
**Shared types:** The epistemic gate protocol is the contract:
1. Skill presents artifact
2. Skill presents 2-3 exploratory epistemic act prompts referencing specific artifact content
3. User responds to at least one prompt
4. Skill notes obvious factual discrepancies
5. Skill asks whether to proceed
**Error handling:** If the user provides only non-generative approval ("looks good"), the skill re-presents the prompts with a gentle redirect.
**Owned by:** Orchestrator defines the protocol; each skill implements it.

### Phase Skill → Next Phase Skill (via artifacts)
**Protocol:** File-based. Each skill writes its artifact to the docs directory. The next skill reads it.
**Shared types:** Markdown files at known paths (essay, domain model, ADRs, system design, scenarios).
**Error handling:** If an artifact is missing, the next skill prompts the user (existing behavior).
**Owned by:** Each skill owns its output artifact format.

### Feed-Forward Contract (ADR-004)
**Protocol:** Conversational. In single-session cycles, the user's epistemic responses are in conversation history. In multi-session cycles, the orchestrator's status table summarizes key responses.
**Shared types:** Natural language in conversation context.
**Error handling:** Multi-session persistence is lossy — acknowledged as known limitation (ADR-004).
**Owned by:** Orchestrator (defines the instruction to attend to prior responses).

## Fitness Criteria

| Criterion | Measure | Threshold | Derived From |
|-----------|---------|-----------|-------------|
| Every skill has an epistemic gate | Presence of EPISTEMIC GATE section in SKILL.md | All 5 phase skills + orchestrator protocol | ADR-001, ADR-002 |
| No gate is approval-only | Gate text requires user to produce something | Zero approval-only gates | Invariant 2 |
| Prompts reference specific content | Gate prompts contain artifact-specific references, not generic questions | All prompts reference specific concepts/decisions from the artifact | ADR-003 |
| Prompts use exploratory framing | Gate prompts use open-ended, collaborative tone | Zero quiz-style prompts | ADR-003 |
| Epistemic cost is lightweight | Number of prompts per gate | 2-3 prompts per gate, user performs at least 1 | Invariant 4 |
| Non-generative approval is handled | Gate includes redirect for approval-only responses | All gates include redirect language | Scenarios |
| Factual discrepancy noting exists | Gate includes instruction to note discrepancies without assessing understanding | All gates include discrepancy language | ADR-001 |
| No module owns more than 10 glossary entries | Count of responsibility matrix rows per module | ≤ 10 | Design balance |

## Test Architecture

### Boundary Integration Tests

| Dependency Edge | Integration Test | What It Verifies |
|----------------|-----------------|------------------|
| Orchestrator → Research Skill | Read Research SKILL.md; verify EPISTEMIC GATE section exists and follows protocol | Gate protocol contract satisfied |
| Orchestrator → Model Skill | Read Model SKILL.md; verify EPISTEMIC GATE section exists and follows protocol | Gate protocol contract satisfied |
| Orchestrator → Decide Skill | Read Decide SKILL.md; verify EPISTEMIC GATE section exists and follows protocol | Gate protocol contract satisfied |
| Orchestrator → Architect Skill | Read Architect SKILL.md; verify EPISTEMIC GATE section exists and follows protocol | Gate protocol contract satisfied |
| Orchestrator → Build Skill | Read Build SKILL.md; verify epistemic prompts in scenario completion step | Gate protocol contract satisfied |
| Orchestrator protocol → Workflow modes | Read Orchestrator SKILL.md; verify workflow mode descriptions use epistemic gate language | Approval-only language removed |

### Invariant Enforcement Tests

| Invariant | Enforcement Location | Test |
|-----------|---------------------|------|
| 0: User can speak with authority | Pipeline-wide (cumulative) | Cannot be tested structurally — this is an outcome. All other tests serve it. |
| 1: Understanding requires generation | Each skill's gate section | Verify every gate requires user to produce something |
| 2: Epistemic acts mandatory at every gate | Each skill's gate section + orchestrator protocol | Verify no gate consists solely of approval; verify redirect for non-generative responses |
| 3: Pragmatic automated, epistemic preserved | Each skill (AI generates, gate requires user engagement) | Verify skills still have AI generation steps AND have epistemic gate sections |
| 4: Epistemic cost lightweight | Each skill's gate section | Verify 2-3 prompts per gate |
| 5: Approval is not grounding | Orchestrator protocol | Verify protocol includes epistemic acts, not just approval |
| 6: Scaffolding must fade | Not enforced in v1 — tracked as debt | ADR-005 revisit trigger |
| 7: Epistemic acts bidirectional | Orchestrator feed-forward instruction | Verify orchestrator instructs AI to reference prior gate responses |

### Test Layers

- **Unit:** Read each SKILL.md individually. Verify: EPISTEMIC GATE section exists, contains 2-3 prompts, prompts use exploratory framing, redirect for non-generative approval is present, discrepancy noting instruction is present.
- **Integration:** Verify orchestrator protocol matches what skills implement. Verify workflow mode descriptions are consistent with skill gate sections. Verify feed-forward instruction exists in orchestrator.
- **Acceptance:** The 17 behavior scenarios in `scenarios.md`. These are verified by reading the modified files and confirming the described behavior is present in the prompt text.

## Build Sequence

The following order minimizes risk and allows incremental verification:

1. **Orchestrator first** — update the gate protocol and workflow mode descriptions. This establishes the contract all skills must follow.
2. **Research Skill** — first phase skill. Validates the pattern.
3. **Model Skill** — second skill. Confirms the pattern works for a different artifact type.
4. **Decide Skill** — third skill.
5. **Architect Skill** — fourth skill.
6. **Build Skill** — last skill. Slightly different pattern (per-scenario gates, not per-phase).
7. **Verification pass** — read all files, confirm all scenarios are satisfied.

Each skill change is a single commit. Structure changes (adding the section) and behavior changes (the prompt content) can be combined per-skill since adding a new section is inherently a behavior change.

## Design Amendment Log

| # | Date | What Changed | Trigger | Provenance | Status |
|---|------|-------------|---------|------------|--------|
