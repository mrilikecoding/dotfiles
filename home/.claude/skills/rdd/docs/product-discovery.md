# Product Discovery: Research-Driven Development (RDD)

*2026-03-06*

## Stakeholder Map

### Direct Stakeholders

- **Solo Developer-Researcher** — A developer who uses RDD with an AI agent to build software projects or new features within existing projects. Interacts with every phase of the pipeline, responds at every gate, and makes all workflow decisions. Currently the primary user.

- **Research-Engineer** — Someone using RDD primarily for the research and understanding phases, where the goal is deep comprehension of a problem space rather than (or before) building software. The pipeline's research phase, product discovery, and domain modeling serve as a structured methodology for investigating technical or domain questions — closer to research engineering than traditional software development.

- **Team Lead (using RDD for scoping)** — A technical leader who runs RDD through RESEARCH → ARCHITECT to build deep understanding of a problem space, then hands off artifacts to their team for building. Uses RDD as a leadership thinking tool. Shares artifacts with architecture and product specialists for validation before team handoff. Does not necessarily advocate that the team adopt RDD — the artifacts stand on their own.

- **AI Agent** — The agent executing the skill files. A direct interactor whose capabilities and constraints shape what the pipeline can do. The skill files are literally instructions to this stakeholder.

### Indirect Stakeholders

- **Teammates / Collaborators** — People who inherit, review, or extend projects built with RDD. They encounter the artifacts — especially the product discovery document and system design — without having gone through the gates that produced them. In the team lead scenario, they receive these artifacts as the starting point for their own planning and building.

- **Architecture and Product Specialists** — People the team lead shares artifacts with for feedback before team handoff. They validate the thinking and surface questions the team lead may have missed. Their feedback flows back through the pipeline (external review re-entry).

- **End Users of the Software Built** — The people who use whatever RDD produces. Their needs are mediated through the product discovery phase but they never interact with RDD itself.

- **Organization / Management** — Decision-makers who evaluate whether RDD is worth the time investment compared to shipping faster without it.

## Jobs and Mental Models

### Solo Developer-Researcher

**Jobs:**
- "I want to actually understand what I'm building, not just have AI generate it and hope it works when I need to change it later"
- "I need a structured process that keeps me from skipping the thinking and jumping straight to code"
- "I want the research and decisions captured so I can pick up a project after weeks away and know why things are the way they are"
- "I want to build the right thing, not just build a thing right"
- "I want to use this for new features too, not just whole new projects — any work that's complex enough to benefit from thinking before building"

**Mental Model:**
"I describe what I want to explore, and the pipeline walks me through understanding it — research first, then figure out who it's for, then nail down the vocabulary, make decisions, design the system, and build it. At each step I have to engage with what was produced, not just approve it. The artifacts are my long-term memory for the project."

### Research-Engineer

**Jobs:**
- "I need to deeply investigate a technical or domain question in a structured way"
- "I want the research process itself to build my understanding — not just produce a report"
- "I want to be able to articulate what I've learned clearly enough to explain it to others"

**Mental Model:**
"RDD is a research methodology as much as a development one. The research phase, product discovery, and modeling give me a rigorous way to explore a question. The gates force me to actually engage with what I'm finding, not just collect sources. Even if I never build anything, the understanding is the deliverable."

### Team Lead (using RDD for scoping)

**Jobs:**
- "I need to deeply understand a problem space so I can scope work for my team with confidence"
- "I want to produce artifacts — especially the product discovery doc and system design — that I can hand to my team as the starting point for their own planning and building"
- "I need the research and decisions captured well enough that the team can build from them without having been in the room when the thinking happened"
- "I want to be able to speak to the artifacts — explain and defend the decisions, respond to real questions, thread the needle between system design and product needs"
- "I want the teams that are building to understand the system themselves, so I hand off building rather than doing it solo"

**Mental Model:**
"I run RDD through ARCHITECT to do my homework — build my own understanding and produce handoff artifacts. The essay tells the team why, the product discovery tells them who it's for, the system design tells them what to build. Before handing off to the team, I get feedback from architecture and product folks to validate my thinking. The team does the build how they want, using the artifacts as a guide. They don't need to use RDD — but they need to understand the system, so they should do the building themselves."

### AI Agent

**Jobs:**
- "Execute the skill instructions faithfully and produce artifacts that meet the quality bar"
- "Maintain consistency across phases — vocabulary, invariants, provenance"
- "Facilitate the gates without being patronizing or perfunctory"

**Mental Model:**
"Each skill file is my instruction set for one phase. I read prior artifacts, produce the phase artifact, present it with prompts, and wait for the user to engage before moving on. The orchestrator tells me the sequence and the rules."

## Value Tensions

- **Speed vs. understanding:** RDD explicitly trades velocity for comprehension. The weight of the process is the value proposition — it means thinking critically and intentionally about what to build. This is different from handing a large problem to an agent and saying "build it." The tension is not "is it too heavy?" but rather "when is a problem important enough to warrant this level of intentionality?"

- **Solo gates vs. team handoff:** The gates build the runner's understanding through generation. But when artifacts are handed to a team, the team hasn't gone through those gates — they receive understanding secondhand. The team lead mitigates this by being able to "speak to" the artifacts. And by handing off BUILD, the team gains their own understanding through implementation. But the gap between the runner's deep understanding and the team's artifact-mediated understanding remains a design tension.

- **Terminology precision vs. accessibility:** Terms like "epistemic gate," "invariant," and "backward propagation" are precise and accurate. They are also barriers to adoption. But diluting the terminology dilutes the signal. RDD's rigor is its strength. The terminology may self-select for the audience that will actually follow through — and that may be a feature, not a bug.

- **Personal tool vs. team methodology:** RDD works well as a solo thinking discipline and as a team lead scoping tool. Scaling it to teams running cycles together introduces coordination questions the current pipeline does not address. The "pair-RDD" possibility — two collaborators running a cycle together, both responding at gates — is an unexplored direction.

- **Artifact feedback loop:** Before handoff, the team lead gets feedback from specialists. This intermediate validation step is real workflow but is not formalized in the pipeline. The external review re-entry pattern (specialist feedback flowing back through the pipeline) is confirmed as actual practice but exists only as an open question in the domain model.

## Assumption Inversions

*Note: The inversions below serve a dual purpose. As a critical design exercise, they surface hidden assumptions. But they also function as epistemic acts in their own right — working through "what if this were wrong?" builds the user's understanding of the system. The inversions at the product discovery gate do double duty: questioning assumptions and producing comprehension. This was surfaced during the epistemic gate conversation and confirmed by the user: "They all got me thinking, which is the point."*

| Assumption | Inverted Form | Implications |
|------------|--------------|-------------|
| RDD is valuable because it produces understanding in the person who runs it | What if the primary value is the artifacts, not the understanding? | If artifacts are the product, gates matter less than artifact quality. But the user's experience contradicts this: understanding is what makes the artifacts good. Being able to "speak to" the artifacts — Invariant 0 — requires having gone through the gates. The two are inseparable. |
| The epistemic gates need to be AI-facilitated | What if users could run gates alone, or with another human instead of an AI? | "Pair-RDD" — two collaborators running a cycle together — could recover the pair-programming dynamic lost in agentic coding. The gates become a facilitation structure for human-human dialog, not just human-AI dialog. Worth its own research cycle. |
| A full phased pipeline is necessary | What if a partial run (RESEARCH through ARCHITECT, no BUILD) is the most common valuable use? | The team lead scoping case confirms this is already happening. When the team lead hands off BUILD so the team gains their own understanding through implementation, partial runs are not "Mode C alternatives" — they are a first-class use case with their own rationale. |
| The user works alone with the AI | What if RDD is most valuable as a collaborative exercise? | Pair-RDD could double the epistemic benefit at gates and surface more tacit knowledge. The current pipeline has no affordance for multiple humans at a gate. |
| The terminology barrier limits adoption | What if precise terminology attracts the right users? | People who find "epistemic gate" off-putting might also find the discipline too demanding. Self-selection through terminology may filter for users who will actually follow through. |
| RDD is for starting new projects | What if auditing existing systems (backward mode) is the highest-impact application? | Most software already exists. If RDD's biggest impact is helping teams understand inherited systems, the pipeline's greenfield bias may be misplaced. There are more existing systems than new ones by definition. |

## Product Vocabulary

| User Term | Stakeholder | Context | Notes |
|-----------|-------------|---------|-------|
| "Run a cycle" | Solo Developer | Starting an RDD process for a project | Implies iteration and return, not "execute the pipeline" |
| "The essay" / "the research" | Solo Developer | Referring to RESEARCH output | Natural language, not "research artifact" |
| "The system design" | Solo Developer / Team Lead | The architecture handoff doc | One of the "two docs that matter" |
| "The product discovery doc" | Team Lead | Handoff to product folks for validation | The other doc that matters |
| "Gates" | Solo Developer | The pause points between phases | May drop "epistemic" in casual use |
| "Scoping" | Team Lead | Running RDD through ARCHITECT to prepare work for a team | Not in the domain model — describes partial pipeline runs |
| "Doing my homework" | Team Lead | What RDD helps them do before asking a team to build | The team lead's framing of RDD's value |
| "Handing off" | Team Lead | Giving artifacts to team or specialists | Real workflow, no formal pipeline concept |
| "Getting feedback" | Team Lead | Sharing artifacts with specialists before team handoff | External review loop — real but not formalized |
| "Speaking to it" | Team Lead | Being able to explain and defend decisions | Direct expression of Invariant 0 |
| "Pair-RDD" | (Potential) | Two collaborators running a cycle together | Emerged during this discovery — not yet in the system |
| "Running a cycle on a feature" | Solo Developer | Using RDD for a new feature within an existing project, not just greenfield | Broadens scope beyond "new project" |
| "Research engineering" | Research-Engineer | Using RDD's research and modeling phases as a structured investigation methodology | The pipeline serves research, not just development |

## Product Debt

| Assumption | Baked Into | Actual User Need | Gap Type | Resolution |
|------------|-----------|-----------------|----------|------------|
| Only one workflow mode matters (full pipeline) | Orchestrator Mode A as primary, B/C/D as secondary | RESEARCH→ARCHITECT partial runs are a first-class use case for team leads | Missing workflow | Elevate partial pipeline (scoping mode) to equal standing with full pipeline |
| No handoff concept | All skills write artifacts but have no handoff step | Team leads need to share artifacts with specialists for feedback, then hand off to teams for building | Missing workflow | Consider formalizing a handoff/review step after ARCHITECT (optional, not a gate) |
| External review is not in the pipeline | Open question in domain model | Team leads already get feedback from architecture and product specialists before team handoff | Missing workflow | Formalize external review re-entry as a pipeline operation |
| Single user at gates | All EPISTEMIC GATE sections address one user | Pair-RDD — two collaborators at gates — could recover pair-programming benefits | Over-abstraction (single-user assumption) | Research cycle needed to explore pair-RDD |
| Backward mode is secondary to forward mode | Forward mode is Step 2a, backward mode is Step 2b; pipeline defaults to greenfield | Auditing existing systems may be the highest-impact application | Mental model mismatch | Consider whether backward mode deserves equal or greater emphasis in onboarding and documentation |
