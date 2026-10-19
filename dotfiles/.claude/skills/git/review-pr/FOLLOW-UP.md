# Follow-up mode

The author has pushed fixes after my earlier review. Steps 1 and 2 of `SKILL.md` are done, so `<owner>`, `<repo>`, `<n>` and `<login>` are known.

## Steps

1. **List my threads.**

   ```bash
   gh api graphql -f query='query($o:String!,$r:String!,$n:Int!){repository(owner:$o,name:$r){pullRequest(number:$n){reviewThreads(first:100){nodes{id isResolved isOutdated path line comments(first:3){nodes{author{login} body}}}}}}}' -f o=<owner> -f r=<repo> -F n=<n>
   ```

   Keep the unresolved threads whose first comment is by `<login>`.

2. **Classify each thread** by reading the code now at that location (`git show pr/<n>:<path>`): **fixed**, **not fixed** or **changed differently**. Done when every thread has a class and a one-line reason.

3. **Confirm.** Show a table: thread, file:line, class, reason. Ask with `AskUserQuestion`: resolve the fixed threads / change the classes / cancel.

4. **Resolve** only the **fixed** threads, after I confirm:

   ```bash
   gh api graphql -f query='mutation($id:ID!){resolveReviewThread(input:{threadId:$id}){thread{isResolved}}}' -f id=<threadId>
   ```

   Leave the rest open and say why.

5. **New problems.** Code the author added since my review gets the normal review: continue with step 4 of `SKILL.md` (review) for the new changes only.

## Gotchas

- An outdated thread (`isOutdated`) points at old code; check where the code moved before calling it fixed.
- Resolve nothing on a guess: no clear evidence, the class is "not fixed".
