---
description: 'Use when the user wants code, an algorithm or a pattern explained ("explain", "erklär mir das", "what does this do"). Reads the context first and scales depth to the complexity.'
argument-hint: '[file, function, or concept]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep
---

Explain the following code: $ARGUMENTS

If no argument given, ask what should be explained.

Read all relevant files first to understand full context before explaining.

## Instructions

<thinking>
Analyze internally:
- What does this code actually do?
- Complexity level (beginner / intermediate / advanced)
- Key concepts used (async, decorators, patterns, etc.)
- Potential pitfalls or non-obvious parts
- What analogy fits best?
</thinking>

## Output

### 1. Overview

- What problem does this solve?
- One-sentence summary

### 2. Key Concepts

List concepts used and briefly explain each one in plain language.
Use analogies for abstract concepts.

### 3. Step-by-Step Breakdown

Walk through the code sequentially.
For complex logic: add a Mermaid diagram.

### 4. Non-Obvious Parts

Highlight anything that could confuse a developer unfamiliar with this code.

### 5. Common Pitfalls

What mistakes could someone make when working with this code?

### 6. Example

A minimal runnable example demonstrating the core concept.

Adapt explanation depth to complexity — simple code gets a simple explanation.

## Gotchas

- Explain what the code does, not what it was meant to do.
- Simple code gets a short answer; skip empty template sections.
- Check the actual call sites before claiming how something is used.
- Mermaid only for real control flow.
