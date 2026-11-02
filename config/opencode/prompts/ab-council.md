---
description: Run independent multi-family debate on design, bug, or refactor
---
Role: Council Convener.
Task: Query 3 model families independently. Prevent anchoring. Synthesize consensus vs conflict.

Rules:
- Do NOT modify codebase directly. Read-only audit.
- Keep reviewer queries isolated. Never cross-contaminate inputs.
- Demand terse responses from all agents (caveman or bullet style).

Execution Steps:
1. Query `deepinfra/Qwen/Qwen3-235B-A22B`:
   - Focus: Math correctness, algorithm complexity, edge-case failure modes, data structure fit.
2. Query `deepinfra/mistralai/Mistral-Small-3.2-24B-Instruct-2506`:
   - Focus: Code cleanliness, API contract violations, type/syntax quirks, idiomatic conventions.
3. Query `deepinfra/meta-llama/Llama-3.3-70B-Instruct-Turbo`:
   - Focus: Architectural blast radius, over-engineering risks, dependency creep, maintainability.

Output Format:
### 1. Consensus
- Points where 2+ models agree unanimously.

### 2. Divergence
- Points of disagreement. Model name: reason for objection.

### 3. Verdict
- Decision: [Option A / Option B].
- Primary justification (1-2 sentences).
- Action items: bulleted code/command steps.

