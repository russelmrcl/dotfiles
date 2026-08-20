---
description: Prüft das Jira-Backlog eines Projekts gegen den aktuellen Stand im GitHub-Repo und liefert eine Liste bearbeitbarer Tickets (nur lesend, keine Änderungen).
---

Jira-Projekt-Prefix: $ARGUMENTS

Falls kein Prefix übergeben wurde, kurz nachfragen, welches Jira-Projekt gemeint ist (z.B. "PROJ"), bevor es weitergeht.

Gehe wie folgt vor:

## 1. Backlog aus Jira holen (in einem Rutsch, nicht Ticket für Ticket)

Alle offenen Tickets des Projekts mit dem Prefix `$ARGUMENTS` in **einer** JQL-Abfrage holen (nicht pro Ticket einzeln `getJiraIssue` aufrufen), z.B. `project = $ARGUMENTS AND statusCategory != Done`, mit den Feldern die gebraucht werden (Titel, Beschreibung, Status, updated, issuelinks). Nur wenn für ein einzelnes Ticket später Detailinfos fehlen (z.B. Remote-Links zu PRs nicht im ersten Call enthalten), gezielt für *dieses* Ticket nachladen – nicht pauschal für alle.

Falls Jira per MCP-Tool verbunden ist, das nutzen. Falls kein Jira-Zugriff verfügbar ist, das klar sagen und fragen, ob die Ticketliste stattdessen manuell eingefügt werden soll.

## 2. Repo-Kontext EINMAL holen, nicht pro Ticket (letzte 3–6 Monate reichen)

Diese Schritte **einmal am Anfang** ausführen und die Ergebnisse für alle Tickets wiederverwenden – nicht pro Ticket neu abfragen:

- **Commits der letzten 6 Monate**: `git log --since="6 months ago" --oneline` (nicht die komplette Historie).
- **Offene PRs**: `gh pr list --limit 100` (Standardlimit reicht meist, nicht die komplette PR-Historie durchsuchen).
- **Gemergte PRs der letzten 6 Monate**: `gh pr list --state merged --search "merged:>=$(date -d '6 months ago' +%Y-%m-%d)" --limit 200` – daraus eine einfache Liste "Ticket-Key → PR" bauen (Titel/Branch-Namen nach `$ARGUMENTS-<nummer>`-Mustern durchsuchen), statt für jedes Ticket einzeln `gh pr list` aufzurufen.
- **Code-Struktur überblicken**: einmal grob Ordnerstruktur/README anschauen, um zu wissen wo relevante Module liegen.

## 3. Jedes Ticket bewerten (gegen die bereits geladenen Daten, keine neuen Abfragen pro Ticket)

Für jedes Ticket die in Schritt 2 gesammelten Daten durchsuchen (PR-Liste, Commit-Liste) statt erneut `git`/`gh` aufzurufen. Nur bei echtem Bedarf gezielt `grep`/`rg` für ein spezifisches Stichwort aus einem Ticket laufen lassen, und dann nur in relevanten Ordnern (z.B. `src/`, `lib/`), nicht im ganzen Repo bzw. `node_modules`/`dist`/`build` ausschließen.

Kategorie pro Ticket:

- **✅ Bearbeitbar**: technische Voraussetzungen da, nichts blockiert es, aktuell, ergibt Sinn.
- **⏸️ Aktuell nicht möglich / blockiert**: hängt an offenem Ticket/Feature, ODER technische Grundlage (Library/API/Migration/Infrastruktur) fehlt im Repo noch – konkret benennen was fehlt.
- **🗑️ Veraltet / obsolet**: beschreibt etwas, das im Code so nicht mehr existiert oder anders gelöst ist, ODER ist eigentlich schon erledigt (PR längst gemerged), ODER lange nicht aktualisiert (> 3–6 Monate) UND inhaltlich nicht mehr relevant.

Bei Unsicherheit vorsichtig sein: nur mit konkretem Beleg (PR-Nummer, Codepfad, verlinktes Ticket) als blockiert/veraltet einstufen. Im Zweifel unter "Bearbeitbar" mit Anmerkung "kurz gegenchecken" einsortieren.

## 4. Ausgabe

Direkt im Chat als Markdown-Liste, sortiert nach Kategorie:

```
## ✅ Bearbeitbar (X Tickets)
- **PREFIX-123** – Kurzer Titel
  Kurzer Grund (1 Zeile).

## ⏸️ Aktuell nicht möglich (X Tickets)
- **PREFIX-130** – Kurzer Titel
  Grund: hängt an PREFIX-129 (noch offen) / Library X fehlt noch im Repo.

## 🗑️ Veraltet / obsolet (X Tickets)
- **PREFIX-140** – Kurzer Titel
  Grund: bereits gelöst in PR #456 (gemerged am ...).
```

## Wichtige Leitplanken

- **Rein lesend.** Nichts an Jira-Tickets ändern (Status, Kommentare, Labels) und nichts im Repo ändern (keine Commits, Branches, PRs, Merges). Auch nicht auf Nachfrage im Verlauf – dann höflich darauf hinweisen, dass dieser Command bewusst nur liest.
- Immer konkrete Belege nennen (Ticket-Key, PR-Nummer, Codepfad), keine pauschalen Einschätzungen.
- Bei großem Repo gezielt mit grep/ripgrep nach Stichworten suchen statt alles zu lesen.
- Wenn ein Tool-Call fehlschlägt oder Zugriff fehlt, das transparent sagen statt zu raten.
- **Performance**: Jira-Tickets in einer Abfrage laden, Git/PR-Daten einmal am Anfang laden (letzte 6 Monate) und für alle Tickets wiederverwenden. Keine Tool-Calls pro Ticket wiederholen, die schon einmal für alle Tickets gemacht wurden.