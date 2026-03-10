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

## Feature: Synthesis Phase in Pipeline (ADR-012)

### Scenario: Orchestrator pipeline includes Synthesis as optional terminal phase
**Given** the orchestrator (`rdd/SKILL.md`) describes the Full Pipeline workflow mode
**When** the pipeline sequence is read
**Then** SYNTHESIS appears as an optional phase after BUILD
**And** the SYNTHESIS phase invokes `/rdd-synthesis`
**And** the phase is marked as optional — the pipeline is complete without it

### Scenario: Synthesis available after any terminal phase
**Given** an RDD cycle has completed its terminal phase (BUILD in full pipeline, ARCHITECT in scoping mode)
**When** the user invokes `/rdd-synthesis`
**Then** the skill accepts the invocation and reads the artifact trail from the completed cycle
**And** does not require BUILD to have been the terminal phase

### Scenario: Synthesis requires substantial artifact trail
**Given** an RDD cycle produced only a research essay and domain model (no product discovery, ADRs, or system design)
**When** the user invokes `/rdd-synthesis`
**Then** the skill notes the artifact trail may be too thin for a productive synthesis conversation
**And** asks the user whether to proceed or defer

### Scenario: Orchestrator Available Skills table includes /rdd-synthesis
**Given** the orchestrator skill file exists
**When** the Available Skills table is read
**Then** it includes a row for `/rdd-synthesis` with purpose describing optional post-build synthesis and essay outline production

### Scenario: Orchestrator state tracking table includes SYNTHESIS
**Given** an RDD cycle is in progress and BUILD is complete
**When** the orchestrator displays the status table
**Then** the table includes a SYNTHESIS row after BUILD, shown as optional

### Scenario: Orchestrator Artifacts Summary includes synthesis deliverables
**Given** the orchestrator skill file exists
**When** the Artifacts Summary table is read
**Then** it includes entries for the synthesis outline and the synthesis essay
**And** the synthesis essay entry notes it is written by the user outside the pipeline

## Feature: Synthesis Conversation Structure (ADR-013)

### Scenario: Agent mines artifact trail before conversation
**Given** the user has invoked `/rdd-synthesis`
**When** the skill begins
**Then** the agent reads the full artifact trail (essays, research logs, reflections, domain model, ADRs, product discovery, system design, code)
**And** applies the five novelty signals to produce a ranked list of candidate discoveries
**And** the ranking is ordered by interestingness, not logical importance

### Scenario: Journey review walks through artifact trail chronologically
**Given** the agent has completed artifact trail mining
**When** Phase 1 (journey review) begins
**Then** the agent points to specific moments in the trail — research questions that shifted direction, domain concepts that emerged from tension, ADRs that superseded earlier positions, reflections that surfaced unanticipated connections
**And** at each moment, the agent asks the user to recall and articulate what was happening
**And** the agent does not provide its own interpretation as a substitute for the user's recall

### Scenario: Novelty surfacing presents candidate discoveries for user reaction
**Given** Phase 1 (journey review) is complete
**When** Phase 2 (novelty surfacing) begins
**Then** the agent presents its ranked candidate discoveries from the five novelty signals
**And** asks the user to react: which feel genuinely important, which were surprising then but obvious now, which carry unresolved tension
**And** treats genuine engagement as signal of a live discovery and polite agreement as signal of a dead one

### Scenario: Framing conversation offers narrative lenses without prescribing
**Given** Phase 2 (novelty surfacing) is complete and live discoveries have been identified
**When** Phase 3 (framing conversation) begins
**Then** the agent offers narrative frameworks as lenses to try on (ABT sentence, story spine, braided structure, volta placement)
**And** the writer may adopt, modify, or discard any framework in favor of their own structural impulse
**And** the agent does not insist on any particular narrative form

### Scenario: Outline captures whatever the writer needs to start writing
**Given** Phase 3 (framing conversation) has identified the central question, key turns, and structural form
**When** the outline is produced
**Then** the outline is non-formulaic — there is no required template or structure
**And** the outline identifies the elements the writer needs to begin: central question, key turns, threads, opening, closing implication
**And** the form serves the writer's impulse, not a methodology prescription

### Scenario: User writes essay outside the pipeline
**Given** the synthesis conversation has produced an outline
**When** the pipeline's synthesis phase is complete
**Then** the deliverable is the outline, stored at `./docs/essays/NNN-descriptive-name-outline.md`
**And** the user writes the synthesis essay on their own time, in their own voice
**And** the agent does not write, co-write, or draft the essay

## Feature: Novelty Signal Detection (ADR-013)

### Scenario: Agent detects explicit surprise statements
**Given** the agent is mining the artifact trail
**When** an artifact contains language marking violated expectations ("turned out," "I was wrong about," "unexpectedly," "contrary to what I believed")
**Then** the agent marks the location as a candidate discovery site of type "explicit surprise statement"

### Scenario: Agent detects reframing events
**Given** the agent is mining the artifact trail
**When** the trail shows a shift in problem definition — vocabulary changes, the question being asked changes, or an explicit statement that the original problem was not the real problem
**Then** the agent marks the location as a candidate discovery site of type "reframing event"

### Scenario: Agent detects assumption denials
**Given** the agent is mining the artifact trail
**When** a finding denies an assumption the target audience would hold (per Davis's twelve categories)
**Then** the agent marks the location as a candidate discovery site of type "assumption denial"
**And** identifies which assumption category is denied

### Scenario: Agent detects superseded decisions
**Given** the agent is mining the artifact trail
**When** an ADR has status "Superseded" or the trail contains contradictions between temporally separated entries on the same topic
**Then** the agent marks the location as a candidate discovery site of type "superseded decision"

### Scenario: Agent detects negative case integrations
**Given** the agent is mining the artifact trail
**When** a counter-example forced revision of the working account (acknowledged or unacknowledged)
**Then** the agent marks the location as a candidate discovery site of type "negative case integration"

## Feature: Worth-the-Calories Quality Gate (ADR-014)

### Scenario: Davis test applied during framing conversation
**Given** Phase 3 (framing conversation) is underway
**When** the writer and agent discuss candidate essay topics
**Then** the agent asks: which widely-held assumption does this essay deny?
**And** if no assumption is denied, the agent notes that the framing may not be interesting enough

### Scenario: ABT test applied during framing conversation
**Given** a candidate essay framing has been identified
**When** the agent facilitates quality testing
**Then** the agent asks the writer to express the central claim as: "Context AND more context, BUT complication, THEREFORE consequence"
**And** checks whether the BUT lands — whether the complication is genuinely surprising

### Scenario: Inversion test applied during framing conversation
**Given** a candidate essay framing has been identified
**When** the agent facilitates quality testing
**Then** the agent asks: can the central claim be stated as the negation of something the target audience currently believes?
**And** if not, notes the essay may be confirming rather than challenging

### Scenario: Quality gate returns negative result honestly
**Given** the three quality tests (Davis, ABT, inversion) have been applied
**When** no framing passes all three tests
**Then** the agent communicates honestly that this cycle may not have produced an essay worth writing
**And** does not manufacture interest where none exists
**And** frames this as a valid outcome, not a failure

### Scenario: Writer makes the quality call, not the agent
**Given** the three quality tests have been applied and results discussed
**When** the writer evaluates whether the standard is met
**Then** the agent does not block or approve — the writer decides
**And** the agent's role is to facilitate the tests, not to enforce a pass/fail judgment

## Feature: Synthesis Essay as Narrative Context Rollup (ADR-015)

### Scenario: Orchestrator reads synthesis essay when bootstrapping new session
**Given** a project has a synthesis essay at `./docs/essays/NNN-*.md` written by the user
**When** a new RDD session begins for that project
**Then** the orchestrator includes the synthesis essay as a primary context source
**And** the essay provides narrative thread through the artifact corpus alongside structured artifacts

### Scenario: Synthesis essay answers "what was this project about?"
**Given** a synthesis essay exists for a project
**When** the essay is read as context
**Then** it answers "what was discovered, and why does it matter?" — the narrative that domain models, ADRs, and system designs cannot provide
**And** serves both human readers and AI sessions bootstrapping understanding

## Feature: Synthesis Subsumes Epistemic Gate (ADR-016)

### Scenario: Synthesis conversation requires generation at every step
**Given** the synthesis conversation is underway (any phase)
**When** the user responds at any point
**Then** the user produces something — recalls an experience, reacts to a discovery, articulates what matters, chooses a narrative direction
**And** no step consists solely of the user approving agent output

### Scenario: No separate epistemic gate after outline production
**Given** the synthesis conversation has produced an outline
**When** the outline is complete
**Then** there is no additional epistemic gate bolted onto the end
**And** the conversation itself has served the gate function throughout

### Scenario: Non-generative responses re-engaged during synthesis
**Given** the agent presents a candidate discovery during novelty surfacing
**When** the user responds with polite but non-generative agreement ("yeah that's interesting")
**Then** the agent probes further: "What about it feels important? Does it connect to something you experienced during the cycle?"
**And** seeks genuine engagement rather than accepting surface-level agreement

## Feature: Inversion Principle in Narrative Framing (ADR-017)

### Scenario: Agent offers narrative inversions during framing conversation
**Given** Phase 3 (framing conversation) is underway
**When** the agent offers narrative frameworks
**Then** the agent includes three narrative inversions as lenses to try on:
- "What if the obvious takeaway is wrong?"
- "What if the process is more interesting than the product?"
- "What if the reader's assumed context is the story?"
**And** the writer may use all, some, or none

### Scenario: Orchestrator documents inversion principle with SYNTHESIS level
**Given** the orchestrator describes the inversion principle as a cross-cutting principle
**When** the phase-specific applications are listed
**Then** SYNTHESIS is included: "narrative framing — inverting obvious takeaways, process-vs-product assumptions, reader's assumed context"

## Feature: Conformance — Synthesis Phase in Orchestrator

### Scenario: rdd-synthesis SKILL.md exists
**Given** the synthesis phase has been built
**When** the skill file is read
**Then** it contains the three-phase conversation structure (journey review, novelty surfacing, framing)
**And** includes artifact trail mining as pre-conversation step
**And** includes the worth-the-calories quality gate during framing
**And** does not contain a separate EPISTEMIC GATE section (the conversation subsumes it)

### Scenario: Orchestrator cross-cutting principles include SYNTHESIS for inversion
**Given** the orchestrator lists the inversion principle's phase-specific applications
**When** the list is read
**Then** it includes SYNTHESIS alongside RESEARCH, PRODUCT DISCOVERY, DECIDE, and ARCHITECT

## Feature: Outline as Springboard with Pre-Populated References (ADR-013)

### Scenario: Outline includes pre-populated references with full quotes
**Given** the framing conversation has identified the essay's central question and key discoveries
**When** the outline is produced
**Then** the agent extracts relevant citations from the research log, essays, and reflections
**And** includes full quotes with proper attribution and source context
**And** the writer does not need to hunt for supporting material — it is already in the outline

### Scenario: Citation audit runs before outline finalization
**Given** the outline includes pre-populated references
**When** the outline is being finalized
**Then** the agent runs a citation audit (via `/citation-audit`) on all pre-populated references
**And** verifies that cited works exist, are properly attributed, and that quoted material is accurate
**And** no hallucinated sources reach the writer's outline

### Scenario: Outline is ready to write from immediately
**Given** the synthesis conversation is complete and the outline is finalized
**When** the writer opens the outline
**Then** it contains: narrative structure (central question, turns, threads), pre-populated references with full quotes, and any structural notes from the framing conversation
**And** the writer can begin writing without additional research or material-gathering

## Feature: Cross-Project Prompting During Synthesis (ADR-018)

### Scenario: Agent asks about resonance with writer's other work
**Given** Phase 3 (framing conversation) is underway and a volta or key discovery has been identified
**When** the agent facilitates framing
**Then** the agent asks whether the volta or discovery resonates with the writer's other work or interests
**And** creates conversational space for the writer to draw cross-project connections the local artifact trail cannot see

### Scenario: Cross-project connections emerge from conversation, not file access
**Given** the agent is facilitating cross-project prompting
**When** the writer describes a connection to another project
**Then** the agent explores the connection through conversation — asking what the shared structure is, how the concepts relate, whether it changes the essay's framing
**And** does not attempt to access artifact trails from other projects

## Feature: Orientation Document as Artifact Hierarchy Entry Point (ADR-019)

### Scenario: Orientation document sits at top of three-tier artifact hierarchy
**Given** an RDD cycle has produced artifacts across multiple phases
**When** the artifact hierarchy is consulted
**Then** ORIENTATION.md is Tier 1 (entry point, routes readers)
**And** product-discovery.md and system-design.md are Tier 2 (primary readables)
**And** domain-model.md, essays, ADRs, and scenarios are Tier 3 (supporting material)

### Scenario: Orientation document routes readers to appropriate depth
**Given** a reader (human or AI agent) encounters the artifact corpus for the first time
**When** they read ORIENTATION.md
**Then** they can determine: what the system is, who it serves, what constraints shape it, what artifacts exist, and what the current state is
**And** they know which Tier 2 document to read next based on their role (product stakeholder → product-discovery.md, technical reader → system-design.md)

### Scenario: Orientation document does not duplicate Tier 2 content
**Given** ORIENTATION.md has been generated
**When** its content is compared to product-discovery.md and system-design.md
**Then** it contains only what the reader needs to decide where to go next — not the depth itself
**And** no section reproduces the detail of the Tier 2 documents it routes to

## Feature: Orientation Document Five-Section Structure (ADR-020)

### Scenario: Orientation document contains exactly five sections
**Given** the agent generates ORIENTATION.md
**When** the document is produced
**Then** it contains exactly five sections in this order: What this system is, Who it serves, Key constraints, How the artifacts fit together, Current state
**And** no additional sections are added

### Scenario: "What this system is" section is one paragraph
**Given** the agent is generating section 1 of ORIENTATION.md
**When** the section is complete
**Then** it states the essential purpose in one paragraph
**And** it does not list features or describe architecture
**And** its language is accessible to both product and technical readers

### Scenario: "Who it serves" section compresses stakeholder map
**Given** the agent is generating section 2 of ORIENTATION.md
**When** the section is complete
**Then** it contains stakeholder names and one-line descriptions
**And** it does not reproduce the full Stakeholder Map from product-discovery.md

### Scenario: "Key constraints" section captures 3-5 shaping invariants
**Given** the agent is generating section 3 of ORIENTATION.md
**When** the section is complete
**Then** it lists 3-5 quality attributes or invariants from the domain model
**And** these are the constraints that make this system *this system*
**And** it does not exhaustively list all invariants

### Scenario: "How the artifacts fit together" section is the artifact map
**Given** the agent is generating section 4 of ORIENTATION.md
**When** the section is complete
**Then** it lists each artifact in the corpus with a one-line description and when to read it
**And** the three-tier hierarchy is visible in the organization

### Scenario: "Current state" section reflects pipeline progress
**Given** the agent is generating section 5 of ORIENTATION.md
**When** the section is complete
**Then** it states which phases are complete, what decisions are settled, and what open questions remain
**And** pipeline state is inferred from the artifact trail (which artifacts exist and their content), not from session state

### Scenario: Entire document is readable in under five minutes
**Given** ORIENTATION.md has been generated
**When** the document's length is assessed
**Then** no section exceeds a few short paragraphs
**And** the entire document is readable in under five minutes

## Feature: Agent-Maintained Orientation Document (ADR-021)

### Scenario: Agent generates orientation document from artifact trail
**Given** an RDD cycle has produced artifacts (at minimum, a research essay)
**When** the agent generates ORIENTATION.md
**Then** the agent reads the current artifact trail and distills it into the five-section structure
**And** this is a pragmatic action (Invariant 3) — no epistemic gate is required for the generation itself

### Scenario: User validates generated orientation document
**Given** the agent has generated ORIENTATION.md
**When** the document is presented to the user
**Then** the user reviews the document for accuracy
**And** the agent and user iterate to refine it
**And** this validation is review-based, not generation-based — no epistemic gate

### Scenario: Partial orientation document after RESEARCH phase
**Given** an RDD cycle has completed only the RESEARCH phase
**When** the agent generates ORIENTATION.md
**Then** only section 1 (what the system is) and section 5 (current state) can be populated
**And** the partial orientation is still useful for the user's context
**And** sections 2-4 are either omitted or marked as pending

### Scenario: Orientation document regenerated at natural milestones
**Given** an RDD cycle has completed a phase (e.g., ARCHITECT)
**When** the agent is asked to regenerate ORIENTATION.md or determines it is a natural milestone
**Then** the document is regenerated from the current artifact trail
**And** the document fills out as more artifacts become available

### Scenario: Scoping use case generates orientation document after ARCHITECT
**Given** a team lead has run RDD through RESEARCH → ARCHITECT (scoping mode)
**When** the ARCHITECT phase completes
**Then** the orientation document is generated as a handoff cover letter
**And** it orients the team to the full artifact set for building

### Scenario: Source artifacts are authoritative over orientation document
**Given** ORIENTATION.md contains a claim that contradicts a source artifact (essay, domain model, ADR, product discovery, or system design)
**When** the contradiction is discovered
**Then** the orientation document is regenerated from the source artifacts
**And** the source artifact is NOT corrected to match the orientation document

### Scenario: Orientation document clarity serves as stewardship signal
**Given** ORIENTATION.md has been generated and the user is reviewing it
**When** the document has grown increasingly abstract or internally contradictory compared to prior versions
**Then** this signals the system may be accumulating the wrong kind of complexity
**And** the signal prompts investigation of the architecture, not just revision of the document

## Feature: Conformance — Orientation Document in Pipeline

### Scenario: Orchestrator "two documents that matter" principle amended to three tiers
**Given** the orchestrator skill file (`rdd/SKILL.md`) exists
**When** the file is read
**Then** the design principle references three tiers: orientation (ORIENTATION.md) → primary readables (product-discovery.md, system-design.md) → supporting material
**And** the prior "two documents that matter" language has been amended

### Scenario: Orchestrator Artifacts Summary includes ORIENTATION.md
**Given** the orchestrator skill file exists
**When** the Artifacts Summary table is read
**Then** it includes a row for ORIENTATION.md noting it is cross-phase and regenerated at milestones

### Scenario: System design architectural drivers table reflects three-tier hierarchy
**Given** system-design.md exists
**When** the Architectural Drivers table is read
**Then** the readability design principle acknowledges the three-tier hierarchy with ORIENTATION.md at Tier 1
