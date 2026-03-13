# Roadmap: Pedagogical RDD — Essay 005 Cycle

**Generated:** 2026-03-12
**Derived from:** System Design v4.0, ADRs 022-026

## Work Packages

### WP-A: Architect Skill — Roadmap Generation

**Objective:** Add roadmap generation step to `/rdd-architect` SKILL.md so the architect phase produces a roadmap alongside the system design.

**Changes:**
- Add a step after system design presentation that generates `./docs/roadmap.md`
- Derive work packages from the module decomposition
- Classify each dependency edge as hard/implied/open
- Describe at least one transition state
- Link from system-design.md to roadmap

**Scenarios covered:** 652-659 (Roadmap), 862-867 (Architect generates roadmap)

**Dependencies:** None

---

### WP-B: Conformance Audit Skill

**Objective:** Create new `/rdd-conform` SKILL.md with four operations: audit, remediation, drift detection, graduation.

**Changes:**
- New skill file: `rdd-conform/SKILL.md`
- Audit operation: scan artifact corpus against skill version, produce gap analysis with structural/format severity
- Remediation operation: generate missing artifacts/sections for structural gaps
- Drift detection operation: compare artifacts against implementation (best-effort semantic comparison)
- Graduation operation: produce migration plan (durable knowledge → native docs, RDD artifacts → archive)

**Scenarios covered:** 756-803 (Conformance Audit)

**Dependencies:** None

---

### WP-C: Build Skill — Field Guide Generation

**Objective:** Add field guide generation step to `/rdd-build` SKILL.md, conditional on implementation existence.

**Changes:**
- Add a step during/after BUILD that generates `./docs/references/field-guide.md`
- Map each system design module to implementation state (what exists, partial, planned)
- Connect domain concepts to code-level manifestations
- Surface design rationale not visible in code
- Mark settled vs. in-flux areas

**Scenarios covered:** 692-726 (Field Guide)

**Dependencies:** None

---

### WP-D: Orchestrator — Artifact Hierarchy, Document Sizing, Available Skills

**Objective:** Update orchestrator to recognize new artifacts and cross-cutting principles.

**Changes:**
- Update three-tier artifact hierarchy: roadmap at Tier 2 alongside product-discovery.md and system-design.md; field guide at Tier 3 alongside domain-model.md, essays, ADRs, scenarios
- Add roadmap and field guide to Artifacts Summary table
- Add conformance audit to Available Skills table
- Add document sizing heuristics as cross-cutting principle (five heuristics in priority order)

**Scenarios covered:** 841-861 (Pipeline Conformance), 728-753 (Document Sizing)

**Dependencies:**
- WP-A → **implied logic** (roadmap artifact should be defined in architect skill before orchestrator references it)
- WP-B → **implied logic** (conformance audit skill should exist before orchestrator lists it)
- WP-C → **implied logic** (field guide should be defined in build skill before orchestrator references it)

---

### WP-E: Orchestrator — Scoped Cycles and Deep Work Tool Framing

**Objective:** Add scoped cycle workflow pattern and deep work tool framing to orchestrator.

**Changes:**
- Describe scoped cycle pattern: scope to subfolder → run pipeline phases → graduate
- Subfolder convention (e.g., `docs/features/auth/`)
- Subsystem artifacts respect project-level constraints
- Deep work tool framing: RDD integrates into existing workflows, not a replacement
- Graduation as scoped cycle endpoint

**Scenarios covered:** 807-838 (Scoped Cycles)

**Dependencies:**
- WP-B → **implied logic** (graduation is a conformance audit operation; the audit skill should define it before the orchestrator references the lifecycle)

---

### WP-F: Verification Pass

**Objective:** Cross-cutting verification that all skill files satisfy new scenarios and fitness criteria.

**Changes:**
- Read all modified SKILL.md files
- Verify all 33 new scenarios (652-867) are satisfied
- Run all 13 new fitness criteria checks
- Verify 7 new boundary integration tests pass

**Dependencies:**
- WP-A through WP-E → **hard dependency** (all skills must be updated before verification)

---

## Dependency Graph

```
WP-A (Roadmap Gen)         WP-B (Conformance Audit)         WP-C (Field Guide Gen)
     │  open choice              │  open choice                    │  open choice
     │                           │                                 │
     └───── implied logic ───────┴──── implied logic ──────────────┘
                                 │
                          WP-D (Orchestrator: Artifacts + Sizing)
                                 │
                           implied logic
                                 │
                          WP-E (Orchestrator: Scoped Cycles)
                                 │
                           hard dependency
                                 │
                          WP-F (Verification Pass)
```

**Classification key:**
- **Hard dependency:** WP-F cannot run until all preceding work packages are complete (structural necessity)
- **Implied logic:** WP-D and WP-E reference artifacts defined in WP-A/B/C; building them in order is simpler, but a skilled builder could stub the references and fill in later
- **Open choice:** WP-A, WP-B, and WP-C are genuinely independent — build any first

## Transition States

### TS-1: Individual Skills Updated (after WP-A + WP-B + WP-C)

The three core capabilities exist independently:
- Architect skill generates roadmaps alongside system designs
- Conformance audit skill can audit, remediate, detect drift, and graduate
- Build skill generates field guides when implementation exists

The orchestrator doesn't yet reference these new artifacts or capabilities, but each skill is functional on its own when invoked directly. This is a coherent intermediate state — users can benefit from roadmap generation immediately even before the orchestrator is updated.

### TS-2: Orchestrator Fully Updated (after WP-D + WP-E)

The orchestrator recognizes all new artifacts:
- Artifact hierarchy includes roadmap (Tier 2) and field guide (Tier 3)
- Conformance audit listed in Available Skills
- Document sizing heuristics govern artifact structure
- Scoped cycles supported as first-class workflow pattern
- Deep work tool framing shapes how RDD describes itself

The system is feature-complete but unverified.

### TS-3: Verified (after WP-F) — Target State

All scenarios satisfied, fitness criteria met, boundary tests pass. System Design v4.0 fully realized in skill files.

## Open Decision Points

- **Conformance audit skill naming:** `rdd-conform` is proposed. Alternatives: `rdd-audit` (risk of confusion with citation/argument audit), `rdd-steward` (matches stewardship framing but not the primary action).
- **Field guide file path:** `./docs/references/field-guide.md` is proposed. Alternative: `./docs/field-guide.md` (flatter structure, but references directory keeps Tier 3 material organized).
- **WP-A/B/C ordering:** All three are open choice. A builder might prefer to start with WP-A (roadmap generation) since it's the lightest lift and produces immediate value. Or WP-B (conformance audit) since it's the most novel. The roadmap doesn't prescribe.
