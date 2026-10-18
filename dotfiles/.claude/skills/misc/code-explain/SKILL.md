---
name: code-explain
description: 'Use when the user wants code, an algorithm or a pattern explained ("explain", "what does this do", "how does this work"). Reads the context first and scales depth to the complexity.'
argument-hint: '[file, function, or concept]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep
---

Explain the following code: $ARGUMENTS

No argument: ask what to explain.

## Steps

1. **Read** the code and everything it depends on. Check the real call sites before claiming how something is used. Done when you can say what the code does, not what it was meant to do.
2. **Size the answer.** Rate the complexity (beginner, intermediate, advanced) and note the key concepts, the non-obvious parts and the likely pitfalls. Simple code gets a short answer: skip any Output section that would be empty.
3. **Write** the Output below.

## Output

1. **Overview:** the problem it solves, in one sentence.
2. **Key concepts:** each concept in plain language, with an analogy for abstract ones.
3. **Step-by-step breakdown:** walk through the code in order. Add a Mermaid diagram only for real control flow.
4. **Non-obvious parts:** what could confuse a developer who does not know this code.
5. **Common pitfalls:** mistakes someone could make when working with it.
6. **Example:** a minimal runnable example of the core concept.

## Gotchas

- Explain behavior from the code, never from names or comments alone.
- Explanation only; the code stays unchanged.
