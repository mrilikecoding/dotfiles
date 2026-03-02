# RDD Architect Phase Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add an `rdd-architect` phase to the RDD pipeline and stewardship checkpoints to `rdd-build`, producing three skill file changes.

**Architecture:** Three file changes — one new skill (rdd-architect), one modified skill (rdd-build), one modified orchestrator (rdd). No code, no tests — these are skill definition files (Markdown with YAML frontmatter).

**Tech Stack:** Claude Code skills (Markdown + YAML frontmatter)

---

### Task 1: Create rdd-architect Skill

**Files:**
- Create: `skills/rdd-architect/SKILL.md`

**Step 1: Write the skill file**

Create `skills/rdd-architect/SKILL.md` with the following content. The skill must:
- Follow the same structural conventions as existing RDD skills (YAML frontmatter with name, description, allowed-tools; process steps; important principles section)
- Read invariants first (RDD convention)
- Include both greenfield mode (Steps 1-9 from design doc Part 1) and retrofit mode (Steps R1-R4)
- Produce `./docs/system-design.md` as output artifact
- Include the provenance model (design doc Part 2) — every module entry links back to invariants, ADRs, and essay sections
- Include the design versioning model (design doc Part 3) — version header, design amendment mechanism, amendment log
- Include the "Can I change this?" decision tree
- Include the responsibility matrix as the central artifact (maps every domain concept/action to exactly one owning module)
- Include architectural fitness criteria definition
- Include a design audit step (Step 8)

Reference files for conventions:
- `skills/rdd-decide/SKILL.md` — closest analog for process structure, audit steps, invariant-first reading
- `skills/rdd-build/SKILL.md` — for how to reference the system design as downstream consumer
- `skills/codebase-audit/SKILL.md` — for stewardship language, finding format, and meso-level analysis concepts (do NOT copy wholesale; adapt the relevant ideas)

Key design decisions for the skill content:
- The system design document template must include: version header, architectural drivers, module decomposition (with provenance per module), responsibility matrix, dependency graph, integration contracts, fitness criteria, and a design amendment log
- Retrofit mode detects whether it's greenfield or existing code by checking for existing source files + existing RDD artifacts
- The design audit is internal (not a separate skill invocation) — it's a checklist the architect phase runs before presenting to the user

**Step 2: Verify skill file structure**

Run: `head -5 skills/rdd-architect/SKILL.md` to verify YAML frontmatter is well-formed.
Expected: Valid YAML frontmatter block with `---` delimiters, name, description, allowed-tools.

Also verify line count is reasonable: `wc -l skills/rdd-architect/SKILL.md`
Expected: Roughly 250-400 lines (comparable to rdd-decide at ~180 lines but with retrofit mode and provenance model adding length).

**Step 3: Commit**

```bash
git add skills/rdd-architect/SKILL.md
git commit -m "feat: add rdd-architect skill for system design between decide and build"
```

---

### Task 2: Add Stewardship Checkpoints to rdd-build

**Files:**
- Modify: `skills/rdd-build/SKILL.md`

**Step 1: Read the current rdd-build skill**

Read `skills/rdd-build/SKILL.md` in full.

**Step 2: Apply the following modifications**

The changes to rdd-build are:

**2a. Update Step 1 (Read Prior Artifacts):**
- Add `./docs/system-design.md` as the PRIMARY artifact to read (after invariants)
- The system design replaces the need to read individual ADRs and the full essay — it's the compiled rollup
- Keep domain model invariants as first read (unchanged)
- Keep scenarios as the acceptance criteria (unchanged)
- Change ADR reading to: "Consult ADRs only when provenance chains in the system design need deeper context"
- Change essay reading to: "Consult essays only when provenance chains need research context"

**2b. Add a new section "STEWARDSHIP CHECKPOINTS" after the "WHEN BUILDING REVEALS FLAWS" section:**

This section defines:

**Tier 1: Lightweight Stewardship Check** — triggered at natural scenario boundaries (completing a logical group of scenarios, crossing a component boundary). Evaluates:
1. Responsibility conformance — responsibilities per module vs. system design allocation
2. Dependency direction — imports vs. designed dependency graph
3. Cohesion — is code landing in the module the design assigns?
4. Size signal — disproportionate growth in any file/class
5. Fitness criteria — measurable properties from system design

Format: present as a brief table showing module, designed responsibilities, actual responsibilities, and status (conforming/drifting/violation).

If clean → continue. If flags → tidy or escalate.

**Tier 2: Deep Architecture Review** — triggered when Tier 1 flags can't be resolved with tidying. Runs three focused analyses (not full codebase-audit, just the relevant meso lenses):
- Coupling analysis (actual vs. designed dependencies)
- Intent-implementation alignment (are modules doing what the design says?)
- Invariant enforcement (are invariants enforced where the design says?)

Produces findings using the five-part stewardship format from codebase-audit: observation (with code locations), pattern, tradeoff, question, stewardship recommendation.

If Tier 2 reveals a design problem (not just a code problem), triggers a **Design Amendment**:
1. Propose the amendment in the system design
2. Present to user for approval
3. If approved, update system design and log in Design Amendment Log
4. Continue building from the updated design

**2c. Add a new section "DESIGN AMENDMENTS" after the stewardship checkpoints:**

When build reveals the system design needs to change:
- Never silently modify the system design
- Write the proposed amendment clearly: what changes, why, what triggered it
- Include provenance: which invariants/ADRs are affected
- Present to user
- If approved: update `./docs/system-design.md`, log in the Design Amendment Log
- If rejected: adapt the code to conform to the existing design, or flag for deeper discussion

**2d. Modify Step 2 (Outer Loop)** to insert checkpoint triggers:

After step 4 ("Present to user") and before step 5 ("User approves"), add:
- "If this scenario completes a logical group (a feature, a component boundary crossing), run a Tier 1 Stewardship Check before proceeding to the next group."

**Step 3: Verify modifications**

Run: `wc -l skills/rdd-build/SKILL.md`
Expected: Original was ~210 lines; modified should be roughly 350-450 lines.

Verify no broken markdown: scan for unclosed code blocks or malformed headers.

**Step 4: Commit**

```bash
git add skills/rdd-build/SKILL.md
git commit -m "feat: add stewardship checkpoints and design amendment mechanism to rdd-build"
```

---

### Task 3: Update rdd Orchestrator

**Files:**
- Modify: `skills/rdd/SKILL.md`

**Step 1: Read the current rdd orchestrator**

Read `skills/rdd/SKILL.md` in full.

**Step 2: Apply the following modifications**

**3a. Update AVAILABLE SKILLS table:**

Add row:
```
| `/rdd-architect` | System design with responsibility allocation + provenance | Domain model + ADRs + scenarios |
```

**3b. Update Mode A (Full Pipeline):**

Insert new phase between DECIDE and BUILD:

```
Phase 3: ARCHITECT
└── /rdd-architect — System design → responsibility allocation → fitness criteria
    [Gate: User approves system design before proceeding.]
```

Renumber BUILD to Phase 4 and INTEGRATE to Phase 5.

**3c. Update Mode C (Resume from Decisions):**

Add ARCHITECT phase between DECIDE and BUILD.

**3d. Update State Tracking table:**

Add row for ARCHITECT between DECIDE and BUILD:
```
| ARCHITECT | /rdd-architect | ☐ Pending | — | — |
```

**3e. Update Cross-Phase Integration section:**

Add these integration points:
- `/rdd-architect` composes ADRs, domain model, and scenarios into a system design with provenance chains linking back to research
- `/rdd-architect` responsibility matrix prevents god-classes by allocating domain concepts/actions to modules before code is written
- `/rdd-build` reads the system design as its primary context (compiled rollup), not the full artifact set
- `/rdd-build` stewardship checkpoints verify architectural conformance at natural scenario boundaries
- If `/rdd-build` stewardship review reveals a design flaw, a Design Amendment updates the system design (not the ADRs)

**3f. Update Artifacts Summary table:**

Add row:
```
| ARCHITECT | System design | `./docs/system-design.md` |
```

**Step 3: Verify modifications**

Check that the phase numbering is consistent throughout the file. Check that no existing content was accidentally deleted.

**Step 4: Commit**

```bash
git add skills/rdd/SKILL.md
git commit -m "feat: add architect phase to RDD pipeline orchestrator"
```

---

### Task 4: Final Verification

**Step 1: Verify all three skill files are well-formed**

Read the YAML frontmatter of each modified/created file:
- `skills/rdd-architect/SKILL.md` — new file
- `skills/rdd-build/SKILL.md` — modified
- `skills/rdd/SKILL.md` — modified

Verify each has valid `---` delimited frontmatter with name and description.

**Step 2: Cross-reference artifact paths**

Verify consistency: every reference to `./docs/system-design.md` appears in all three files where appropriate. The system design path must be the same in the architect skill (which produces it), the build skill (which reads it), and the orchestrator (which lists it in the artifacts table).

**Step 3: Verify git status is clean**

Run: `git status`
Expected: Clean working tree, all changes committed.
