---
name: chat-message
description: 'Use when the user wants a chat message written or rewritten for Slack, Teams, Discord, WhatsApp or similar ("write a Slack message", "reply in the thread", "this sounds like AI", "draft a reply"). Produces a short message that sounds like the user, based on the humanizer patterns.'
argument-hint: '[platform] [what to say, or the message to rewrite]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep
---

Write or rewrite a chat message so it reads like a colleague typed it: $ARGUMENTS

Use anything pasted as input too (thread, draft, notes). The message is in the language of the input.

## Steps

1. **Find the reader and the goal.** Who gets this (person, channel, thread), and what should they do or know afterwards? Done when you can state the goal in one sentence. A reply that depends on a thread you cannot see: ask for the thread.
2. **Set the register** from the platform and the relationship:
   - Slack, Discord, WhatsApp with the team: casual, fragments and lowercase starts are fine, informal address.
   - Teams, cross-team, manager or customer: plain and polite, full sentences, formal address only if I use it.
   - Thread reply: the reader has the context (rule 1).

   A writing sample from me overrides this; match its length, punctuation and emoji habits.

3. **Draft.** Lead with the decision, answer or ask. Keep only the reasoning that could change whether the reader agrees, plus any link they need to act. Done when the first sentence alone lets the reader act.
4. **Check the rules** below and cut. Done when no rule matches and every sentence tells the reader something new.
5. **Return** the final message in one code block, ready to paste. Add at most one line after it, only for an open question or a detail you had to leave out.

## Rules (from humanizer)

1. **Reply to a reader who has context.** No restating the problem, no walk-through of the diagnosis, no proof for a plan. Details belong in the ticket or doc; link it (§26).
2. **State the point.** No "not X but Y", "to be clear", "I'm not saying", "Here's the thing", "Let that sink in", no closer that repeats the message (§1, §2, §4, §5).
3. **No chatbot wrapper.** No "Great question!", "Certainly!", "I hope this helps", "Let me know if you have any questions". One concrete ask ("can you look at it by Thursday?") is fine (§22).
4. **No sales or inflation.** No "thrilled to announce", "game-changer", "exciting", "seamless" (§13, §16).
5. **Structure only when it earns it.** Plain text by default. A list for three or more parallel items the reader will tick off; bold for at most one key term; no headings, no emoji strings, no bold labels (§19, §20).
6. **Punctuation.** No dashes as connectors, no curly quotes, no forced triads (§6, §8, §21).
7. **Keep facts.** Names, numbers, dates, ticket IDs, links and @mentions come from me or the thread. A missing detail: ask, or write a simpler sentence.
8. **Short.** One to four sentences for most replies. A longer message puts the ask or decision in its first line and gets a TL;DR if it needs scrolling.

## Platform notes

- **Slack:** `*bold*`, `_italic_`, `` `code` ``, `>` quote, `<@user>` only when I gave the handle. Long content goes in a thread reply, not the channel.
- **Teams:** Markdown subset (`**bold**`, lists, `code`). A reply in the thread beats a new post.
- **Discord:** standard Markdown, short.
- **WhatsApp, Signal:** no formatting beyond `*bold*`, no link without a reason.

## Gotchas

- Drafting only. Sending or posting needs my explicit go.
- A polite closing ("Thanks!", "Best regards") is a human habit, not chatbot residue; keep it when the register calls for it.
- Match my level of warmth. Thanks and apologies stay as big as I made them.
- Rewriting a message of mine: keep the meaning and the quirks, change only what sounds machine-made.
- Long-form text (posts, announcements, docs) is the job of the humanizer skill: call the Skill tool with "humanizer" when it is installed.
