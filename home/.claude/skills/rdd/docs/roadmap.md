# Roadmap: Pedagogical RDD — Essay 005 + 006 Cycles

**Generated:** 2026-03-12
**Derived from:** System Design v5.0, ADRs 022-030

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

---

## Essay 006 Cycle: Synthesis Enrichment (ADRs 027-030)

The following work packages address the synthesis skill's conformance debt — 9 violations identified during the essay 006 DECIDE phase. All modifications target `rdd-synthesis/SKILL.md` and its supporting orchestrator text.

### WP-G: Synthesis Skill — Framing Conversation Overhaul

**Objective:** Replace the flat lens-based framing approach with four-dimension navigation via structural experiments, making the framing conversation a discovery mechanism rather than a selection exercise.

**Changes:**
- Replace or restructure the current framing conversation (Phase 3) to navigate four dimensions: discovery type, narrative form, audience constraint, epistemic posture
- Add narrative form vocabulary: three tiers (established patterns, hermit crab forms, meta-forms)
- Add epistemic posture dimension (determined/exploratory/indeterminate)
- Add audience constraint as creative catalyst (not just "who reads this")
- Add structural experiment mechanism: agent proposes externalized trials, writer executes; failures are diagnostic; agent's draft is catalyst not submission
- Preserve existing elements that work: worth-the-calories tests, narrative inversion lenses, cross-project prompting

**Scenarios covered:** Four-Dimension Framing Model (6 scenarios), Structural Experiments (6 scenarios)

**Dependencies:** None

---

### WP-H: Synthesis Skill — Two-Register Outline

**Objective:** Update outline production to explicitly identify both registers — argumentative backbone and curatorial arrangement — giving the writer vocabulary for the experiential dimension.

**Changes:**
- Update outline production step to identify argumentative backbone (logical thread verified by argument audit)
- Add curatorial arrangement identification: selection, juxtaposition, scale shifts, shimmer, negative space, personal voice
- Ensure argument audit checks the argumentative register only (curatorial register assessed through judgment)
- Maintain existing outline elements: central question, key turns, opening scene, closing implication, structural notes, pre-populated references

**Scenarios covered:** Two-Register Outline (6 scenarios)

**Dependencies:**
- WP-G → **implied logic** (the framing conversation shapes what goes into the outline; updating the outline format is simpler after the framing conversation is restructured, but a builder could update the outline template first and fill in the framing dimension references later)

---

### WP-I: Synthesis Skill — Re-Entry Logic

**Objective:** Add the ability for synthesis to re-enter RESEARCH when structural experimentation surfaces new questions, and update terminal language throughout.

**Changes:**
- Update "Synthesis is the terminal phase. There is no next phase." → "Synthesis is usually terminal"
- Add re-entry section: conditions (structural experiment reveals incoherence, writer cannot explain material, framing surfaces unaddressed question)
- Specify writer-decision constraint: writer must articulate the research question; if they cannot, incoherence is a framing problem solvable within synthesis
- Specify narrow scoping: re-entry targets a specific question, not the entire cycle
- Specify conversation resumption: synthesis conversation may pause and resume rather than restart
- Update NEXT PHASE section to reflect re-entry possibility
- Update orchestrator SKILL.md: synthesis listed as "usually terminal" with conditional re-entry

**Scenarios covered:** Synthesis Re-Entry (6 scenarios)

**Dependencies:**
- WP-G → **implied logic** (re-entry is triggered by structural experiments; understanding how they work in the framing conversation makes the re-entry conditions clearer, but the re-entry logic is a separate section that could be written independently)

---

### WP-J: Synthesis Conformance Verification

**Objective:** Cross-cutting verification that synthesis skill satisfies all 31 new scenarios and 7 new fitness criteria.

**Changes:**
- Read modified `rdd-synthesis/SKILL.md`
- Verify all 31 new scenarios (synthesis enrichment from ADRs 027-030) are satisfied
- Run all 7 new fitness criteria checks
- Verify 3 new boundary integration tests pass
- Verify conformance debt table violations are all resolved

**Dependencies:**
- WP-G, WP-H, WP-I → **hard dependency** (all synthesis skill changes must be complete before verification)

---

## Updated Dependency Graph

```
Essay 005 Cycle:

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
                          WP-F (Verification Pass — Essay 005)


Essay 006 Cycle:

WP-G (Framing Overhaul)
     │  open choice
     ├───── implied logic ─── WP-H (Two-Register Outline)
     ├───── implied logic ─── WP-I (Re-Entry Logic)
     │                              │
     └──── hard dependency ─────────┴──── hard dependency
                                 │
                          WP-J (Verification Pass — Essay 006)


Cross-cycle:

WP-F and WP-J are independent — they verify different skill files.
WP-I (re-entry) updates orchestrator SKILL.md; if WP-D/WP-E have already
modified the orchestrator, WP-I must account for those changes.
```

**Classification key:**
- **Hard dependency:** Cannot build the downstream package without the upstream being complete (structural necessity)
- **Implied logic:** Simpler to build in this order, but not required — a skilled builder could stub and fill later
- **Open choice:** Genuinely independent — build any first

## Updated Transition States

### TS-1: Individual Skills Updated (after WP-A + WP-B + WP-C)

(Unchanged from above — essay 005 cycle transition state.)

### TS-2: Orchestrator Fully Updated (after WP-D + WP-E)

(Unchanged from above — essay 005 cycle transition state.)

### TS-3: Essay 005 Verified (after WP-F)

All essay 005 scenarios satisfied. System Design v5.0 roadmap/field guide/conformance/scoping features fully realized in skill files. Synthesis skill still uses pre-essay-006 framing approach.

### TS-4: Synthesis Enriched (after WP-G + WP-H + WP-I)

Synthesis skill uses four-dimension framing via structural experiments, produces two-register outlines, and can re-enter RESEARCH. The skill is feature-complete for essay 006 but unverified.

### TS-5: Fully Verified (after WP-F + WP-J) — Target State

All scenarios satisfied across both cycles, all fitness criteria met, all boundary tests pass. System Design v5.0 fully realized in skill files.

## Updated Open Decision Points

- **Conformance audit skill naming:** (unchanged)
- **Field guide file path:** (unchanged)
- **WP-A/B/C ordering:** (unchanged)
- **Cross-cycle ordering:** The essay 005 cycle (WP-A through WP-F) and essay 006 cycle (WP-G through WP-J) are largely independent — they modify different files. A builder could interleave them (e.g., do WP-G before WP-D) or run them sequentially. The one cross-cycle dependency: WP-I modifies the orchestrator, so if WP-D/WP-E have already been applied, WP-I must account for those changes.
- **Framing conversation structure:** WP-G is the heaviest lift. The current Phase 3 (framing conversation) has an established structure with lenses. How much of that structure to preserve vs. replace is a judgment call during BUILD — the ADRs prescribe the four dimensions and structural experiments, but the exact prompt text layout is a design decision for the builder.
