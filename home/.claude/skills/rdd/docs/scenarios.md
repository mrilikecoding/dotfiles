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
