# Behavior Scenarios

## Feature: Epistemic Gates at Phase Transitions

### Scenario: RESEARCH gate presents epistemic act prompts after essay
**Given** the `/rdd-research` skill has produced an essay artifact
**When** the skill presents the essay to the user at the gate
**Then** the skill also presents 2-3 exploratory epistemic act prompts referencing specific content from the essay
**And** the prompts use open-ended, collaborative framing (not quiz-style)
**And** the skill waits for the user to respond to at least one prompt before offering to proceed

### Scenario: MODEL gate presents epistemic act prompts after domain model
**Given** the `/rdd-model` skill has produced a domain model artifact
**When** the skill presents the domain model to the user at the gate
**Then** the skill presents 2-3 epistemic act prompts referencing specific concepts and relationships from the model
**And** the skill waits for the user to respond before offering to proceed

### Scenario: DECIDE gate presents epistemic act prompts after ADRs
**Given** the `/rdd-decide` skill has produced ADRs and behavior scenarios
**When** the skill presents the ADRs to the user at the gate
**Then** the skill presents epistemic act prompts referencing specific decisions and rejected alternatives
**And** the skill waits for the user to respond before offering to proceed

### Scenario: ARCHITECT gate presents epistemic act prompts after system design
**Given** the `/rdd-architect` skill has produced a system design
**When** the skill presents the system design to the user at the gate
**Then** the skill presents epistemic act prompts referencing specific modules, boundaries, and responsibility allocations
**And** the skill waits for the user to respond before offering to proceed

### Scenario: BUILD gate presents epistemic act prompts per scenario group
**Given** the `/rdd-build` skill has completed a scenario group
**When** the skill presents the completed work to the user
**Then** the skill presents reflection-in-action or self-explanation prompts referencing the specific scenario and test outcomes
**And** the skill waits for the user to respond before proceeding to the next scenario group

### Scenario: Gate does not advance without user generation
**Given** any RDD skill has presented an artifact and epistemic act prompts at a gate
**When** the user responds with only "approved", "looks good", "yes", or similar non-generative confirmation
**Then** the skill acknowledges the approval but reiterates that the gate asks for the user's perspective on the artifact
**And** the skill re-presents the epistemic act prompts

### Scenario: AI notes factual discrepancies in user's epistemic response
**Given** a user has performed an epistemic act at any gate
**When** the user's response contains a factual discrepancy with the artifact (e.g., misattributing a concept, misstating a decision)
**Then** the AI notes the specific discrepancy without framing it as an error ("The artifact describes X as Y — your take was Z. Worth revisiting?")
**And** the AI does not attempt to assess the depth or quality of the user's understanding

## Feature: Orchestrator Epistemic Gate Protocol

### Scenario: Orchestrator gate protocol includes epistemic acts
**Given** the RDD orchestrator (`rdd/SKILL.md`) defines the stage gate protocol
**When** the orchestrator describes the gate interaction pattern
**Then** the protocol includes: present artifact, present epistemic act prompts, user responds, note discrepancies, ask whether to proceed
**And** the protocol states that no gate may consist solely of approval

### Scenario: Orchestrator workflow modes reflect epistemic gates
**Given** the orchestrator describes workflow modes (Full Pipeline, Research Only, Resume, Custom)
**When** each mode lists the gate at each phase transition
**Then** the gate description uses "epistemic gate" language, not "user approves" language

## Feature: Epistemic Responses Enrich Subsequent Phases

### Scenario: AI references user's prior epistemic response in next phase
**Given** the user performed an epistemic act at the RESEARCH gate, expressing particular emphasis or concern about a finding
**When** the `/rdd-model` skill begins the MODEL phase
**Then** the AI's domain model extraction attends to the user's stated emphasis — e.g., if the user highlighted a concept as central, the model treats it accordingly

### Scenario: Multi-session context preservation
**Given** an RDD cycle spans multiple sessions
**When** the orchestrator resumes the pipeline in a new session
**Then** the status table includes a summary of the user's key epistemic responses from prior gates
**And** the AI in the new session references these summaries when generating artifacts

## Feature: Conformance — Skill Files Implement Epistemic Gates

### Scenario: rdd-research SKILL.md contains an epistemic gate section
**Given** the `/rdd-research` skill file exists
**When** the file is read
**Then** it contains an EPISTEMIC GATE section with 2-3 exploratory prompts specific to essay artifacts

### Scenario: rdd-model SKILL.md contains an epistemic gate section
**Given** the `/rdd-model` skill file exists
**When** the file is read
**Then** it contains an EPISTEMIC GATE section with 2-3 exploratory prompts specific to domain model artifacts

### Scenario: rdd-decide SKILL.md contains an epistemic gate section
**Given** the `/rdd-decide` skill file exists
**When** the file is read
**Then** it contains an EPISTEMIC GATE section with 2-3 exploratory prompts specific to ADR artifacts

### Scenario: rdd-architect SKILL.md contains an epistemic gate section
**Given** the `/rdd-architect` skill file exists
**When** the file is read
**Then** it contains an EPISTEMIC GATE section with 2-3 exploratory prompts specific to system design artifacts

### Scenario: rdd-build SKILL.md contains epistemic gate prompts
**Given** the `/rdd-build` skill file exists
**When** the file is read
**Then** the scenario completion step includes reflection-in-action and self-explanation prompts

### Scenario: rdd orchestrator SKILL.md reflects updated gate protocol
**Given** the orchestrator skill file exists
**When** the file is read
**Then** the Stage Gates section describes the 5-step epistemic gate protocol
**And** the workflow mode descriptions use epistemic gate language

### Scenario: rdd-product SKILL.md contains an epistemic gate section
**Given** the `/rdd-product` skill file exists
**When** the file is read
**Then** it contains an EPISTEMIC GATE section with 2-3 exploratory prompts specific to product discovery artifacts
**And** prompts reference specific stakeholders, jobs, value tensions, or assumption inversions from the artifact

## Feature: Product Discovery Phase in Pipeline (ADR-006)

### Scenario: Orchestrator pipeline includes Product Discovery between RESEARCH and MODEL
**Given** the orchestrator (`rdd/SKILL.md`) describes the Full Pipeline workflow mode
**When** the pipeline sequence is read
**Then** PRODUCT DISCOVERY appears after UNDERSTAND (RESEARCH) and before MODEL
**And** the PRODUCT DISCOVERY phase invokes `/rdd-product`

### Scenario: Orchestrator Available Skills table includes /rdd-product
**Given** the orchestrator skill file exists
**When** the Available Skills table is read
**Then** it includes a row for `/rdd-product` with purpose "Product discovery — stakeholder maps, jobs, value tensions, assumption inversions" and invocation by topic or essay

### Scenario: Orchestrator state tracking table includes PRODUCT DISCOVERY
**Given** an RDD cycle is in progress
**When** the orchestrator displays the status table
**Then** the table includes a PRODUCT DISCOVERY row between UNDERSTAND and MODEL

### Scenario: Orchestrator Artifacts Summary includes product discovery artifact
**Given** the orchestrator skill file exists
**When** the Artifacts Summary table is read
**Then** it includes a row: PRODUCT DISCOVERY | Product discovery document | `./docs/product-discovery.md`

## Feature: Product Discovery Artifact Structure (ADR-007)

### Scenario: Product discovery artifact contains five sections
**Given** `/rdd-product` has completed forward-mode discovery
**When** the product discovery artifact (`./docs/product-discovery.md`) is read
**Then** it contains sections for: Stakeholder Map, Jobs and Mental Models, Value Tensions, Assumption Inversions, and Product Vocabulary Table
**And** all sections use user-facing language, not system vocabulary

### Scenario: Stakeholder Map includes direct and indirect stakeholders
**Given** `/rdd-product` is producing a stakeholder map
**When** the map is complete
**Then** it identifies both direct stakeholders (who interact with the system) and indirect stakeholders (who are affected without interacting)
**And** it does not use the term "persona" for the stakeholder entries

### Scenario: Product Vocabulary Table includes stakeholder attribution
**Given** `/rdd-product` has completed the Product Vocabulary Table
**When** the table is read
**Then** each term includes: User Term, Stakeholder (who uses this term), Context, and Notes

## Feature: Forward and Backward Operating Modes (ADR-008)

### Scenario: Forward mode produces discovery artifact from essay
**Given** no prior RDD artifacts exist for the system (greenfield)
**And** `/rdd-research` has produced an essay
**When** `/rdd-product` runs
**Then** it operates in forward mode
**And** it reads the essay as primary input
**And** it produces the five-section product discovery artifact (ADR-007)

### Scenario: Backward mode produces product debt table from existing artifacts
**Given** prior RDD artifacts exist (domain model, ADRs, system design)
**When** `/rdd-product` runs
**Then** it operates in backward mode
**And** it reads existing architecture, ADRs, and domain model
**And** it extracts implicit product assumptions from architectural choices
**And** it produces the five-section product discovery artifact plus a Product Debt table

### Scenario: Product Debt table maps assumption gaps
**Given** `/rdd-product` is running in backward mode
**When** it identifies a gap between an architectural assumption and actual user need
**Then** the Product Debt table includes a row with: Assumption, Baked Into (which artifact/code encodes it), Actual User Need, Gap Type, and Resolution

### Scenario: Backward mode product debt triggers amendment propagation
**Given** `/rdd-product` backward mode has identified product debt items
**When** a debt item affects the domain model (e.g., invalidates a concept or invariant)
**Then** the item triggers backward propagation through the existing amendment infrastructure
**And** an amendment is logged in the domain model's Amendment Log

## Feature: Product Vocabulary Provenance in Domain Model (ADR-009)

### Scenario: Domain model Concepts table includes Product Origin column
**Given** `/rdd-model` runs after `/rdd-product` has produced a product discovery artifact
**When** the domain model Concepts table is produced
**Then** it includes a Product Origin column tracing each system term to its user-facing source

### Scenario: Infrastructure-only concepts marked without product origin
**Given** `/rdd-model` is populating the Product Origin column
**When** a system concept has no user-facing equivalent (pure infrastructure)
**Then** the Product Origin column contains "—" with a brief note explaining why

### Scenario: System concepts with multiple product origins list all sources
**Given** a system concept maps to terms used by multiple stakeholders
**When** the Product Origin column is populated
**Then** it lists all sources (e.g., "Open enrollment crunch" (Benefits Admin), "Enrollment period" (HR Manager))

### Scenario: /rdd-model reads product discovery artifact
**Given** `/rdd-product` has produced a product discovery artifact at `./docs/product-discovery.md`
**When** `/rdd-model` begins Step 1 (Read the Source Material)
**Then** it reads the product discovery artifact alongside the essay
**And** it uses the Product Vocabulary Table as input for the Product Origin column

## Feature: Inversion Principle Governance (ADR-010)

### Scenario: /rdd-product includes assumption inversion as procedural step
**Given** `/rdd-product` is running in forward mode
**When** it reaches the Assumption Inversions section
**Then** for each major product assumption, it states the inverted form and its implications
**And** this is the primary procedural home of the Inversion Principle

### Scenario: Orchestrator documents inversion principle as cross-cutting principle
**Given** the orchestrator skill file exists
**When** it is read
**Then** it includes the Inversion Principle as a cross-cutting principle alongside existing principles
**And** it lists the phase-specific questions: RESEARCH ("right problem?"), PRODUCT DISCOVERY (procedural step), DECIDE ("unexamined product assumption?"), ARCHITECT ("user's mental model or developer's?")

### Scenario: /rdd-decide checks ADRs against unexamined product assumptions
**Given** `/rdd-decide` is writing or auditing ADRs
**When** an ADR's context section references a product assumption
**Then** the skill checks whether that assumption has been validated through product discovery
**And** if not, flags it as a potential inversion principle violation

### Scenario: /rdd-architect checks boundaries against user mental models
**Given** `/rdd-architect` is designing module boundaries
**When** a boundary encodes a product assumption (e.g., "carriers are interchangeable")
**Then** the skill asks whether the boundary serves the user's mental model or just the developer's
**And** documents the answer in the responsibility matrix provenance

## Feature: Product Discovery Epistemic Gate (ADR-011)

### Scenario: PRODUCT DISCOVERY gate presents epistemic act prompts after artifact
**Given** `/rdd-product` has produced a product discovery artifact
**When** the skill presents the artifact to the user at the gate
**Then** the skill presents 2 exploratory epistemic act prompts referencing specific stakeholders, jobs, tensions, or inversions from the artifact
**And** the skill waits for the user to respond to at least one prompt before offering to proceed

### Scenario: PRODUCT DISCOVERY gate surfaces user tacit knowledge
**Given** the user has responded to a PRODUCT DISCOVERY gate prompt
**When** the user's response includes product knowledge not present in the artifact (e.g., a stakeholder behavior, an unarticulated workflow, a domain nuance)
**Then** the AI notes this new information and asks whether to incorporate it into the artifact before proceeding

### Scenario: PRODUCT DISCOVERY gate detects business-first vs user-first framing
**Given** the user is responding to a PRODUCT DISCOVERY gate prompt
**When** the user's language reveals business-first framing ("our sales team needs...") rather than user-first framing ("admins experience...")
**Then** the AI notes the framing orientation without judgment, making it visible for the user to consider

## Feature: Cross-Phase Integration — Product Discovery Feed-Forward

### Scenario: Product discovery value tensions propagate as open questions into MODEL
**Given** the product discovery artifact contains Value Tensions
**When** `/rdd-model` runs
**Then** unresolved value tensions appear in the domain model's Open Questions section

### Scenario: Product discovery assumption inversions become behavior scenarios in DECIDE
**Given** the product discovery artifact contains Assumption Inversions
**When** `/rdd-decide` runs
**Then** inverted assumptions are considered as candidate behavior scenarios

### Scenario: ARCHITECT provenance chains extend to user needs
**Given** `/rdd-architect` is building the responsibility matrix
**When** a module is assigned ownership of a domain concept
**Then** the provenance chain traces: Module → Domain Concept → ADR → Product Discovery (stakeholder/job/value)
**And** a product stakeholder can follow this chain to understand why the module exists
