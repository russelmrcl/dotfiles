---
name: grill-me
description: 'Stress-test a plan or design, one question at a time, each with a recommended answer.'
argument-hint: '[plan, idea, or design to stress-test]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep
disable-model-invocation: true
---

Stress-test this plan or design: $ARGUMENTS

No argument: use the plan from the current conversation.

## Steps

1. **Ask one question per message** and wait for the answer. Give your recommended answer with each question so I can reply "yes". Name the risk behind the question in one sentence.
2. **Look up before asking.** The codebase answers it: read the code.
3. **Walk the decision tree depth-first.** Resolve a decision's dependencies before moving on.
4. **Pin down vague terms** ("fast", "simple", "user") with a concrete case.
5. **Finish** when every open decision has an answer, with a short summary:
   - **Decided** (bullets)
   - **Still open** (bullets, with owner)
   - **Riskiest assumption**

## Gotchas

- The output is decisions. Implementation starts elsewhere.
