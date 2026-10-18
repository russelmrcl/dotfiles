---
name: wait-what
description: 'Re-explain your last message in plain language.'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep
disable-model-invocation: true
---

I did not understand where you have got to. Re-explain your last message, in the language of my last message.

## Steps

1. **Context:** one or two sentences on what this is about.
2. **Plain words:** short sentences, one idea per sentence, no unexplained jargon. A project term gets used exactly as the code or CLAUDE.md spells it, and explained once.
3. **Decision:** end with the result or the decision I have to make. Done when it is the last thing I read.

## Gotchas

- Explanation only. New tasks and changes wait.
- Different words for the same text do not help; lead with the result.
