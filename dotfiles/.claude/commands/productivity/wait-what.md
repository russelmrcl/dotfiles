---
description: "Use when the user says they didn't understand the last message (\"wait what\", \"versteh ich nicht\", \"nochmal einfacher\"). Re-explains it briefly in plain German."
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep
disable-model-invocation: true
---

Ich habe nicht verstanden, wo du gerade stehst. Erkläre deine letzte Nachricht neu:

1. Ein, zwei Sätze Kontext: worum geht es überhaupt?
2. Kurze Sätze, ein Gedanke pro Satz, keine unerklärten Fachbegriffe.
3. Dann das Ergebnis oder die Entscheidung, die ich treffen soll.
4. Wenn ein Begriff aus dem Projekt stammt, benutze genau diesen (siehe CLAUDE.md / Code).

Sprache: Deutsch, außer ich schreibe Englisch.

## Gotchas

- Don't repeat the same text with different words; lead with the decision or result.
- Explain each project term once, using the project's own word.
- No new tasks or changes — explanation only.
