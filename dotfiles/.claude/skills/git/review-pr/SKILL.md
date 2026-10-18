---
name: review-pr
description: 'Review a teammate PR/MR, draft inline comments, post them as a pending review.'
argument-hint: '[PR/MR number or URL; default: PR of the current branch]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Write, Agent, AskUserQuestion
disable-model-invocation: true
---

Review this pull request: $ARGUMENTS

The author is a teammate. Goal: a review they can act on, as inline comments on the affected lines, posted as a **pending** review I submit.

## Steps

### 1. Detect platform and pin the PR

```bash
git remote get-url origin
```

- `github.com`: GitHub, use `gh`
- `gitlab`: GitLab, use `glab`
- Neither CLI installed or not logged in: say so and stop. Offer to write the review to `.scratch/review-<id>.md` instead.

GitHub:

```bash
gh pr view <n> --json number,title,body,author,baseRefName,headRefName,headRefOid,additions,deletions,changedFiles,reviews
gh pr diff <n>
gh repo view --json nameWithOwner -q .nameWithOwner
```

GitLab:

```bash
glab mr view <iid>
glab mr diff <iid>
```

No argument: PR of the current branch. None found: ask for a number and stop.

To read full files at the PR head, fetch the ref instead of checking out (checkout changes my working tree):

```bash
git fetch origin pull/<n>/head:refs/remotes/pr/<n>
git show pr/<n>:<path>
```

Done when you have the diff, the description and the head SHA.

### 2. Find the spec

Look for a ticket key in the title or branch, a linked issue, the PR description, `docs/`, `specs/`. Not found: "no spec available", skip the Spec axis. A missing spec is not a finding.

### 3. First review or follow-up?

Existing review threads by me on this PR: **follow-up mode** (step 7). Otherwise continue.

### 4. Review

Three axes, kept separate:

- **Standards:** correctness, edge cases, missing `await`, TypeScript strictness, NestJS DI/guard/pipe order, DTO validation, error handling, N+1, tests that couple to implementation. Baseline: the project's CLAUDE.md and 2-3 comparable files.
- **Spec:** requirements missing, partial or wrong; behaviour added that was not asked for. Quote the spec line.
- **Security:** untrusted input traced to a sink, authn/authz, secrets, injection.

Size gate: ≤ 5 files **and** ≤ 200 lines **and** nothing security-sensitive: review yourself. Otherwise launch one subagent per axis **in one message** (`Agent` tool), each with the diff command, the spec and its axis only.

Read the surrounding code, not only the changed lines.

### 5. Draft the comments

One comment per issue, anchored to the **exact line in the new file**. Format (Conventional Comments):

```
<label> [blocking|non-blocking]: <what and why, in one or two sentences>

<suggestion block or concrete fix, when there is one>
```

| Label        | Use for                                                |
| ------------ | ------------------------------------------------------ |
| `issue`      | A bug or violated requirement. Usually blocking        |
| `suggestion` | A better way, with the concrete change                 |
| `question`   | Something unclear that you could not resolve from code |
| `nitpick`    | Style, naming. Always non-blocking                     |
| `praise`     | Something done well. Include one or two where deserved |

Each comment:

- Explains the **consequence** ("this throws when `user` is null on the refresh path"), not just the rule.
- Asks a question when intent is unclear.
- Addresses the code, not the person: "we" or "this", not "you".
- Uses a ` ```suggestion ` block for fixes of up to a few lines.
- Leaves out what ESLint, Prettier or tsc already enforce.

Max ~15 comments. More: keep the blocking ones and summarise the rest in the body. One root cause gets one comment, with "applies to X, Y, Z too".

Also draft a **summary body**: one paragraph on what the PR does and your overall impression, then the per-axis result (Standards / Spec / Security) and the blocking points as a list.

### 6. Preview and confirm

Show a table: `#`, `file:line`, label, blocking?, first sentence. Then the summary body.

Ask with `AskUserQuestion`: post as pending review / edit first / write to file only / cancel.

Post only after "post". The review stays pending: approving, requesting changes and submitting happen in the UI after I read it.

#### GitHub: pending review

Write the payload to `.scratch/review-<n>.json`. Omitting `event` creates a pending review:

```json
{
  "commit_id": "<headRefOid>",
  "body": "<summary body>",
  "comments": [{ "path": "src/a.ts", "line": 42, "side": "RIGHT", "body": "issue [blocking]: …" }]
}
```

```bash
gh api repos/<owner>/<repo>/pulls/<n>/reviews --method POST --input .scratch/review-<n>.json
```

#### GitLab: draft notes

One draft note per comment; I publish them in the MR:

```bash
glab api --method POST projects/:id/merge_requests/<iid>/draft_notes \
  -f note='…' \
  -f 'position[position_type]=text' \
  -f 'position[base_sha]=<base>' -f 'position[start_sha]=<start>' -f 'position[head_sha]=<head>' \
  -f 'position[new_path]=<path>' -f 'position[old_path]=<path>' -f 'position[new_line]=<line>'
```

SHAs come from `glab api projects/:id/merge_requests/<iid>`, field `diff_refs`.

Done when you have reported what was posted and where to submit it.

### 7. Follow-up mode

The author has pushed fixes:

```bash
gh api graphql -f query='query($o:String!,$r:String!,$n:Int!){repository(owner:$o,name:$r){pullRequest(number:$n){reviewThreads(first:100){nodes{id isResolved isOutdated path line comments(first:3){nodes{author{login} body}}}}}}}' -f o=<owner> -f r=<repo> -F n=<n>
```

For each unresolved thread of mine, read the code now at that location and classify it **fixed**, **not fixed** or **changed differently**. Show the table. After confirmation, resolve only the **fixed** threads:

```bash
gh api graphql -f query='mutation($id:ID!){resolveReviewThread(input:{threadId:$id}){thread{isResolved}}}' -f id=<threadId>
```

Leave the rest open and say why.

## Gotchas

- A comment on a line outside the diff makes the API reject the **whole** review (422). Check every `line` against the diff's new-file line numbers first.
- Posting is visible to the team. Always preview and confirm.
- Review the diff, not the whole file. Pre-existing problems are `nitpick` at most, or left out.
- Subagents have no context: paste the diff command, spec and axis brief into each prompt.
- Nothing is staged, committed or pushed.
