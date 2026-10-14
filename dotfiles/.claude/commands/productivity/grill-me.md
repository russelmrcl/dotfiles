---
description: Interview me relentlessly about a plan or design until it holds up
argument-hint: "[plan, idea, or design to stress-test]"
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep
disable-model-invocation: true
---

Stress-test this plan or design: $ARGUMENTS

If nothing was passed, use the plan from the current conversation.

## Rules

- Ask **one question at a time**. Wait for the answer before the next.
- Give your **recommended answer** with each question so I can just say "yes".
- If the codebase can answer a question, look it up instead of asking.
- Walk the decision tree depth-first: resolve dependencies between decisions before moving on.
- Challenge vague terms ("fast", "simple", "user") and ask for the concrete case.
- Name the risk you see behind each question in one sentence.

## Done when

Every open decision has an answer. Then give a short summary:
- **Decided** (bullets)
- **Still open** (bullets, with owner)
- **Riskiest assumption**
