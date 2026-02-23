# Domain Model: llm-conductor

## Concepts (Nouns)

| Term | Definition | Related Terms |
|------|-----------|---------------|
| **Conductor** | The Claude Code skill that acts as workflow architect, decomposing meta-tasks and orchestrating execution across Claude and local models via llm-orc | Meta-Task, Workflow Plan |
| **Meta-Task** | A complex, multi-phase goal described in natural language that the conductor decomposes into subtasks. Examples: "build a PromotionHandler," "run an RDD research cycle" | Subtask, Workflow Plan, Task |
| **Task** | A unit of work that can be routed as-is to an ensemble or handled by Claude. A simple task is routed directly; a meta-task is decomposed into subtasks first | Task Type, Routing Decision |
| **Subtask** | An individual unit of work within a decomposed meta-task. The level at which competence boundaries and routing decisions apply | Meta-Task, Task Type, Workflow Plan |
| **Task Type** | A classification of work that determines routing. Three categories: agent-delegable (extraction, classification, template fill, summarization, mechanical transform, boilerplate generation), ensemble-delegable (cross-file analysis, decomposable multi-step reasoning, evidence gathering, factual knowledge retrieval, tool-based scanning), or Claude-only (recursive reconsideration, interacting constraints, holistic judgment, novel insight, aesthetic judgment) | Task, Subtask, Routing Decision, Delegability Category |
| **Delegability Category** | One of three classifications for a task type: agent-delegable (single small model handles it), ensemble-delegable (exceeds agent competence but passes the DAG decomposability test), or Claude-only (fails the DAG decomposability test) | Task Type, DAG Decomposability Test |
| **Workflow Plan** | The conductor's decomposition of a meta-task into an ordered sequence of subtasks, each assigned to either an ensemble or Claude-direct. Includes estimated token savings. Presented to the user for approval before execution | Meta-Task, Subtask, Delegation Assignment |
| **Delegation Assignment** | The mapping of a single subtask within a workflow plan to its handler: a specific ensemble, a new ensemble to be created, or Claude-direct | Workflow Plan, Subtask, Ensemble |
| **Ensemble** | A programmable system of agents in llm-orc that collectively process input and produce output. May contain LLM agents, script agents, and ensemble agents orchestrated via dependencies, fan-out, and conditional execution | Agent, Profile, Ensemble Tier |
| **Multi-Stage Ensemble** | An ensemble that combines script agents (gathering/parsing), fan-out LLM agents (per-item analysis), and a synthesizer. Follows the gather-analyze-synthesize pattern. Handles ensemble-delegable tasks that exceed any individual agent's competence | Ensemble, Script Agent, Fan-out, Template Architecture |
| **Universal Ensemble** | An ensemble covering a subtask pattern that recurs across virtually all software projects. Created proactively as infrastructure the conductor depends on, not reactively | Ensemble, Starter Kit |
| **Starter Kit** | The set of universal ensembles the conductor creates during its first session: extract-code-patterns, generate-test-cases, fix-lint-violations, write-changelog, write-commit-message | Universal Ensemble |
| **Agent** | A processing unit within an ensemble. Three types: LLM agent (model with system prompt and profile), script agent (Python/bash script with JSON I/O), ensemble agent (sub-ensemble invocation). Agents are connected via dependencies in a DAG | Profile, Ensemble, Script Agent, Ensemble Agent |
| **LLM Agent** | An agent that uses a local model to process input. Configured with a system prompt and model profile. Subject to agent-level competence boundaries: bounded, single-concern work only | Agent, Profile, Competence Boundary |
| **Script Agent** | An agent that runs an arbitrary Python or bash script taking JSON input and returning JSON output. Handles non-LLM complexity: file I/O, web searches, AST parsing, static analysis tools, ML classifiers, test runners. Scripts absorb the complexity that would otherwise make tasks Claude-only | Agent, Multi-Stage Ensemble |
| **Ensemble Agent** | An agent that invokes an entire sub-ensemble as a pipeline step. Enables recursive composition of ensemble capabilities | Agent, Ensemble |
| **Profile** | A named configuration binding a model identifier and provider to a system prompt and parameters | Model Tier, Agent |
| **Model Tier** | A capability classification for local models: micro (sub-1B), small (1-3B), medium (4-7B), ceiling (12B) | Profile |
| **Conductor Profile** | One of three standard model profiles for conductor-internal ensemble use: conductor-micro (qwen3:0.6b, per-item extraction/comparison), conductor-small (gemma3:1b, bounded analysis/template fill), conductor-medium (llama3 8B default; gemma3:12b only when synthesizing 4+ upstream outputs per ADR-005 ceiling rule) | Profile, Model Tier, Multi-Stage Ensemble |
| **Swarm** | An ensemble pattern where many small extractors feed medium analyzers feed a larger synthesizer; composition over scale | Ensemble, Model Tier |
| **Fan-out** | An orchestration primitive where an upstream agent outputs an array and the downstream agent spawns one instance per element, processing in parallel. Results are gathered back (fan-in) into an ordered array. The scalability mechanism for multi-stage ensembles | Multi-Stage Ensemble, Agent |
| **Input Key Selection** | An orchestration primitive where an agent selects a specific JSON key from upstream output, enabling routing patterns where a classifier directs different data to different downstream agents | Agent, Ensemble |
| **Conditional Dependency** | An orchestration primitive where agent execution is gated on upstream output values, enabling branching within an ensemble | Agent, Ensemble |
| **Template Architecture** | A reusable multi-stage ensemble pattern that the conductor customizes per-project. Examples: document consistency checker, cross-file code analyzer, knowledge researcher, multi-file test generator, debugging evidence gatherer. All follow the gather-analyze-synthesize pattern | Multi-Stage Ensemble, Ensemble |
| **DAG Decomposability Test** | The practical discriminator for whether a task is ensemble-delegable. A task passes if it meets four conditions: (1) DAG-decomposable — no cycles or backtracking, (2) script-absorbable — non-LLM complexity handled by scripts, (3) fan-out-parallelizable — LLM work divides into bounded per-item tasks, (4) structured-synthesizable — synthesis combines structured per-item outputs. If all four hold: ensemble-delegable. If any fails: Claude-only | Delegability Category, Task Type, Multi-Stage Ensemble |
| **Ensemble-Prepared Claude** | A workflow pattern where an ensemble handles the gathering and analysis phases of a Claude-only task, producing a structured brief. Claude receives the brief and performs only the final judgment, consuming dramatically fewer tokens than processing raw input | Multi-Stage Ensemble, Routing Decision, Token Savings |
| **Routing Decision** | The conductor's choice to delegate a subtask to a local ensemble or handle it directly via Claude. Made per-subtask within a workflow plan | Task Type, Ensemble, Evaluation, Delegability Category |
| **Invocation** | A single execution of an ensemble via llm-orc's MCP `invoke` tool | Ensemble, Artifact |
| **Artifact** | The execution result from an llm-orc invocation, containing per-agent outputs, token usage, timing, and model metadata | Invocation, Token Usage |
| **Token Usage** | Per-agent and total counts of input/output tokens, cost, and duration recorded in an artifact | Artifact, Token Savings |
| **Token Savings** | The delta between local tokens consumed and estimated Claude tokens for the same subtask. For ensemble-prepared Claude subtasks, savings are: estimated full Claude tokens minus (preparation tokens local + judgment tokens Claude) | Token Usage, Routing Decision, Ensemble-Prepared Claude |
| **Evaluation** | Claude's quality judgment of ensemble output, scored on a 3-point rubric (poor/acceptable/good) with CoT reasoning | Artifact, Score, Reflection |
| **Score** | The verdict of an evaluation: poor, acceptable, or good | Evaluation |
| **Reflection** | The verbal chain-of-thought reasoning Claude produces before rendering a score; stored as the `reasoning` field | Evaluation |
| **Failure Mode** | A categorized reason an ensemble output was scored poorly: hallucination, incomplete, wrong-format, off-topic | Evaluation, LoRA Candidate |
| **Calibration** | The mandatory evaluation period for a new ensemble — first 5 uses are always evaluated. Ensembles are usable during calibration (trust-but-verify) but not yet established | Ensemble, Evaluation |
| **Pattern-as-Calibration** | The mechanism by which Claude's prior correct outputs (observed before ensemble creation) serve as implicit calibration data encoded in the ensemble's system prompt | Calibration, Subtask |
| **Complexity Floor** | The threshold below which delegation overhead exceeds the value of delegating a subtask. Determined by subtask complexity, verifiability, reversibility, and contextuality | Subtask, Routing Decision |
| **Repetition Threshold** | The minimum expected repetitions (3+) of a subtask pattern before ensemble creation is worthwhile. Below this, Claude handles the subtask directly | Complexity Floor, Ensemble |
| **Routing Config** | Versioned thresholds and preferences that guide routing decisions, updated from accumulated evaluations | Routing Decision, Task Profile |
| **Task Profile** | A learned mapping from a task type to recommended model tier and ensemble pattern, persisted in `task-profiles.yaml` | Task Type, Routing Config |
| **LoRA Candidate** | A task type flagged for fine-tuning because local models consistently score "poor" on it (3+ poor evaluations with a consistent failure mode) | Task Type, Failure Mode, Data Flywheel |
| **Data Flywheel** | The accumulating corpus of (input, output, claude_judgment) triples that serve as training data for LoRA fine-tuning and local judge training | Evaluation, LoRA Candidate, Local Judge |
| **Local Judge** | A future LoRA-trained Ollama model that replicates Claude's evaluation capability, reducing evaluation cost to zero | Data Flywheel, Evaluation |
| **Ensemble Tier** | The storage location and scope of an ensemble: local, global, or library | Ensemble, Promotion |
| **Local Tier** | Project-specific ensembles stored in `{project}/.llm-orc/ensembles/`; where all ensembles are born | Ensemble Tier |
| **Global Tier** | User-wide reusable ensembles stored in `~/.config/llm-orc/ensembles/` | Ensemble Tier |
| **Library Tier** | Community-contributed ensembles in the `llm-orchestra-library` git repo | Ensemble Tier |
| **Promotion** | Moving an ensemble from one tier to a higher one (local → global → library) based on quality evidence and generality | Ensemble Tier, Generality Assessment |
| **Generality Assessment** | Claude's evaluation of whether an ensemble is project-specific or portable across projects | Promotion, Ensemble |
| **Competence Boundary** | The empirically-determined limit of what can be reliably handled, operating at two levels. Agent-level: no individual LLM agent handles multi-step reasoning (3+ steps), complex instructions (>4 constraints), or tasks requiring world knowledge or holistic judgment. Ensemble-level: a composed system of script agents, fan-out LLM agents, and synthesizers can handle tasks exceeding agent competence, provided the task passes the DAG decomposability test | Model Tier, Task Type, Routing Decision, DAG Decomposability Test |

### Synonyms to Avoid

| Preferred Term | Avoid | Reason |
|---------------|-------|--------|
| Meta-Task | Goal, Project, Job | "Meta-Task" distinguishes decomposable work from simple routable tasks |
| Subtask | Step, Sub-task, Action item | "Subtask" is the decomposition unit; hyphenated "sub-task" is inconsistent |
| Workflow Plan | Execution plan, Delegation plan, Strategy | "Workflow Plan" is the specific artifact the conductor produces |
| Task | Request, Query, Job | "Task" is used consistently in the routing literature |
| Universal Ensemble | Starter ensemble, Infrastructure ensemble | "Universal" conveys cross-project applicability |
| Evaluation | Judgment, Assessment, Review | "Evaluation" is the container; "Score" is the verdict within it |
| Promotion | Migration, Deployment | "Promotion" implies quality-gated advancement through tiers |
| Ensemble | Pipeline, Workflow, Chain | "Ensemble" is llm-orc's term; use it everywhere |
| Profile | Config, Model Config | "Profile" is llm-orc's term for model configuration |
| Reflection | Critique, Feedback | "Reflection" comes from the Reflexion pattern literature |
| Conductor | Router, Orchestrator, Broker | "Conductor" is the skill's name; its role is workflow architect |
| Swarm | Chain, Pipeline | "Swarm" describes the many-small-to-few-large composition pattern specifically |
| Decompose | Break down, Split, Partition | "Decompose" is the standard term in task decomposition literature |
| Script Agent | Script, Plugin, Extension | "Script Agent" is llm-orc's term; it's an agent type, not a standalone script |
| Fan-out | Broadcast, Map, Distribute | "Fan-out" is llm-orc's term for array-to-parallel-instances |
| Template Architecture | Blueprint, Skeleton, Boilerplate | "Template Architecture" is a reusable ensemble pattern, not code scaffolding |
| Ensemble-Prepared Claude | Assisted Claude, Pre-processed | "Ensemble-Prepared" conveys that the ensemble prepares context for Claude's judgment |
| Multi-Stage Ensemble | Pipeline, Multi-step ensemble | "Multi-Stage" distinguishes from single-agent ensembles; avoids "pipeline" (reserved for non-ensemble flows) |
| Delegability Category | Routing category, Task class | "Delegability Category" names the three-way classification explicitly |

## Actions (Verbs)

| Action | Actor | Subject | Description |
|--------|-------|---------|-------------|
| **Decompose** | Conductor | Meta-Task | Break a meta-task into an ordered sequence of subtasks, classifying each by task type and delegability category |
| **Plan** | Conductor | Workflow Plan | Create a workflow plan with delegation assignments for each subtask, estimated savings, and ensemble creation needs. Present to user for approval |
| **Triage** | Conductor | Subtask | Classify a subtask by task type, apply the DAG decomposability test, and assign a delegability category (agent-delegable, ensemble-delegable, or Claude-only) |
| **Route** | Conductor | Subtask | Dispatch a subtask to an ensemble (local) or handle directly (Claude) per the workflow plan |
| **Discover** | Conductor | Ensembles, Models | Query llm-orc for available ensembles (`list_ensembles`) and models (`get_provider_status`) |
| **Compose** | Conductor | Ensemble | Design and create a new ensemble to fill a gap identified in the workflow plan. For multi-stage ensembles, includes authoring script agents and selecting template architectures |
| **Author Script** | Conductor | Script Agent | Write a Python or bash script as part of multi-stage ensemble composition. Claude writes the script (a judgment task); the script then runs locally without Claude. Includes validating JSON I/O contracts |
| **Invoke** | Conductor | Ensemble | Execute an ensemble via llm-orc MCP with input data |
| **Evaluate** | Conductor (as judge) | Artifact | Score ensemble output quality using a 3-point rubric with CoT reflection |
| **Reflect** | Conductor | Evaluation | Produce verbal reasoning about why output succeeded or failed before scoring |
| **Calibrate** | Conductor | Ensemble | Evaluate every invocation during an ensemble's first 5 uses to establish baseline quality |
| **Sample** | Conductor | Invocation | Probabilistically select invocations for evaluation (10-20% after calibration) |
| **Quantify** | Conductor | Token Savings | Calculate the delta between local tokens used and estimated Claude equivalent |
| **Adapt** | Conductor | Workflow Plan | Modify the plan during execution — fall back to Claude if ensemble output is poor, create new ensembles if patterns emerge |
| **Promote** | Conductor (with user consent) | Ensemble | Copy an ensemble from one tier to a higher one, including profile dependencies |
| **Assess Generality** | Conductor | Ensemble | Read ensemble YAML and evaluate whether it is project-specific or portable |
| **Contribute** | Conductor (with user consent) | Ensemble | Push a library-worthy ensemble to the llm-orchestra-library repo via git |
| **Flag** | Conductor | Task Type | Mark a task type as a LoRA candidate after repeated poor evaluations |
| **Adjust** | Conductor | Routing Config | Update routing thresholds based on accumulated evaluation evidence |
| **Bootstrap** | Conductor | Starter Kit | Create the set of universal ensembles during the conductor's first session in a project |
| **Test DAG Decomposability** | Conductor | Subtask | Evaluate whether a subtask passes the four conditions (DAG-decomposable, script-absorbable, fan-out-parallelizable, structured-synthesizable) to determine if it is ensemble-delegable |
| **Prepare** | Conductor | Ensemble-Prepared Claude | Run an ensemble to gather and analyze context, then present a structured brief to Claude for final judgment on a Claude-only subtask |

## Relationships

- **Conductor** decomposes **Meta-Tasks** into **Subtasks**
- **Conductor** plans, executes, and adapts **Workflow Plans**
- **Conductor** triages, routes, evaluates, promotes, and authors scripts — it is the sole actor
- **Meta-Task** decomposes into one or more **Subtasks**
- **Subtask** has one **Task Type**
- **Task Type** belongs to one **Delegability Category** (agent-delegable, ensemble-delegable, or Claude-only)
- **Delegability Category** is determined by the **DAG Decomposability Test**
- **Workflow Plan** orders **Subtasks** and assigns each a **Delegation Assignment**
- **Delegation Assignment** maps a **Subtask** to either an **Ensemble** or Claude-direct
- **Routing Decision** maps a **Subtask** to either an **Ensemble** or Claude-direct
- **Routing Decision** is informed by **Routing Config** and **Task Profiles**
- **Ensemble** contains one or more **Agents**
- **Agent** is one of three types: **LLM Agent**, **Script Agent**, or **Ensemble Agent**
- **LLM Agent** references exactly one **Profile**
- **Script Agent** runs a script with JSON I/O; no profile needed
- **Ensemble Agent** invokes a sub-**Ensemble**
- **Profile** specifies a **Model Tier**
- **Conductor Profile** is a **Profile** standardized for conductor-internal use (micro, small, medium)
- **Universal Ensemble** is an **Ensemble** that belongs to the **Starter Kit**
- **Ensemble** belongs to one **Ensemble Tier** (local, global, or library)
- **Multi-Stage Ensemble** is an **Ensemble** that combines **Script Agents**, **Fan-out**, and **LLM Agents** in a gather-analyze-synthesize pattern
- **Multi-Stage Ensemble** may follow a **Template Architecture**
- **Fan-out** spawns parallel instances of a downstream **Agent** from an upstream array
- **Invocation** executes one **Ensemble** and produces one **Artifact**
- **Artifact** contains **Token Usage** (per-agent and totals)
- **Evaluation** scores one **Artifact** and produces one **Score** + one **Reflection**
- **Evaluation** may identify a **Failure Mode**
- **Evaluations** accumulate into the **Data Flywheel**
- **Data Flywheel** feeds **LoRA Candidates** and future **Local Judge** training
- **Accumulated evaluations** drive **Routing Config** adjustments
- **Promotion** moves an **Ensemble** from one **Ensemble Tier** to the next
- **Promotion** requires a **Generality Assessment** (for global) and quality evidence (for library)
- **Token Savings** are computed from **Token Usage** (actual) vs estimated Claude equivalent
- **LoRA Candidate** is flagged from a **Task Type** with 3+ poor **Evaluations** sharing a **Failure Mode**
- **Competence Boundary** operates at two levels: agent-level (constrains individual **LLM Agents**) and ensemble-level (constrains composed systems via the **DAG Decomposability Test**)
- **Complexity Floor** determines whether delegating a **Subtask** is worth the overhead
- **Repetition Threshold** gates **Ensemble** creation for newly observed **Subtask** patterns
- **Ensemble-Prepared Claude** uses a **Multi-Stage Ensemble** to prepare context, then routes the judgment phase to Claude-direct
- **Template Architecture** is instantiated as a **Multi-Stage Ensemble** customized for a specific project or task

## Invariants

1. **The user always decides.** The conductor recommends routing, promotion, LoRA training, ensemble creation, and workflow plans. It never acts on these without explicit user consent.

2. **Claude is the safe default.** When the conductor cannot confidently route a subtask to a local ensemble — due to subtask complexity, missing ensembles, or insufficient evaluation history — the subtask stays with Claude.

3. **Composition over scale.** The conductor prefers swarms of small models (≤7B) over reaching for larger models (12B). 12B is the ceiling, not the norm. The swarm pattern — many extractors → fewer analyzers → one synthesizer — is the primary architecture. This extends to multi-stage ensembles: scripts + small LLMs compose into systems that handle what no model alone could.

4. **New ensembles must be calibrated.** The first 5 invocations of any new ensemble are always evaluated. No ensemble enters the "established" category without calibration data. Ensembles are usable during calibration (trust-but-verify); calibration gates skipping evaluation, not usage.

5. **Evaluation is sampled, not universal.** After calibration, only 10-20% of invocations are evaluated. Evaluation cost must not exceed the token savings it enables. Well-established ensembles (>20 uses, >80% acceptance) skip routine evaluation.

6. **Promotion requires evidence.** An ensemble must have 3+ "good" evaluations to be promoted to global. An ensemble must have 5+ "good" evaluations and pass a generality assessment to be contributed to the library. Quality gates are non-negotiable.

7. **Token savings are always quantified.** Every routing decision logs local tokens consumed and estimated Claude equivalent. The conductor can always report cumulative savings.

8. **Evaluations are training data.** Every evaluation record (input, output, score, reflection) is persisted as a potential LoRA fine-tuning example. The data flywheel is a first-class design concern, not an afterthought.

9. **Routing config is versioned.** Every adjustment to routing thresholds creates a new version. Degradation can be rolled back to any prior version.

10. **Competence boundaries operate at two levels.** Agent level: no individual LLM agent within an ensemble handles multi-step reasoning (3+ steps), complex instructions (>4 constraints), or tasks requiring world knowledge or holistic judgment — regardless of model size. Ensemble level: a composed system of script agents, fan-out LLM agents, and synthesizers can handle tasks that exceed any individual agent's competence, provided the task decomposes into a DAG where each LLM node stays within agent-level boundaries. Tasks are genuinely Claude-only only when they require recursive reconsideration, interacting constraints, holistic judgment, novel insight, or aesthetic judgment that no decomposition can produce.

11. **Ensembles carry their dependencies.** When promoting an ensemble, the conductor checks that all referenced profiles exist at the destination tier and offers to copy missing ones. For multi-stage ensembles, the conductor also verifies script portability: no hardcoded project paths, declared Python/system dependencies available at the destination. A promoted ensemble must be runnable at its destination.

12. **The conductor is the workflow architect.** When invoked with a meta-task, the conductor decomposes it into subtasks and designs a workflow plan that maximizes local model leverage — reserving Claude for subtasks that genuinely require frontier reasoning. The conductor owns the workflow, not individual routing decisions in isolation.

13. **Workflow plans precede execution.** The conductor presents its workflow plan — decomposition, delegation assignments, ensemble creation needs, and estimated savings — to the user before beginning work on a meta-task.

## Amendment Log

| # | Date | Invariant | Change | Propagation |
|---|------|-----------|--------|-------------|
| 1 | 2026-02-20 | Inv 2 | Changed "task" to "subtask" — routing decisions now apply at subtask level within workflow plans | ADR for task triage (ADR-002) needs update to reflect subtask-level routing |
| 2 | 2026-02-20 | Inv 4 | Added clarification: "Ensembles are usable during calibration (trust-but-verify); calibration gates skipping evaluation, not usage" | Scenarios for calibration need new scenario: ensemble used during calibration period |
| 3 | 2026-02-20 | Inv 10 | Added clarification: "Competence boundaries constrain individual subtask routing decisions; the conductor may decompose any meta-task regardless of its overall complexity" | Scenarios for competence boundaries need update; essay already reflects this |
| 4 | 2026-02-20 | Inv 12 | **ADDED** — The conductor is the workflow architect (local-first objective for meta-tasks) | New concept; needs ADR. First essay's router framing is superseded for meta-tasks |
| 5 | 2026-02-20 | Inv 13 | **ADDED** — Workflow plans precede execution | Extension of Inv 1 (user decides) to workflow planning; needs scenarios |
| 6 | 2026-02-20 | Inv 10 | **AMENDED** — Replaced single-level "to local models" wording with two-level competence model (agent-level + ensemble-level). Added DAG decomposability as the gate for ensemble-level delegation. Added irreducible Claude-only criteria (recursive reconsideration, interacting constraints, holistic judgment, novel insight) | Prior essay "proactive-task-decomposition" § "No Tension After All" is superseded. SKILL.md competence boundaries section needs rewrite from binary to three-category taxonomy. Scenarios need new cases for ensemble-delegable tasks and DAG decomposability test |
| 7 | 2026-02-20 | Inv 3 | **STRENGTHENED** — Extended "composition over scale" to explicitly include multi-stage ensembles (scripts + small LLMs compose into systems) | Consistent with prior wording; no documents contradict |
| 8 | 2026-02-21 | Inv 10 | **AMENDED** — Added "aesthetic judgment" to irreducible Claude-only criteria. Audit found ADR-012 and essay listed 5 criteria but invariant listed only 4 | ADR-012 now consistent with invariant |
| 9 | 2026-02-21 | Inv 11 | **STRENGTHENED** — Extended from "profile dependencies" to "all dependencies" including script portability for multi-stage ensembles | ADR-013 script promotion guidance now has invariant backing |
