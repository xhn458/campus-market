# GitLab and Jira workflow

Every code or documentation change must use a Jira ticket branch and a GitLab Merge Request. The `main` branch contains reviewed, demo-ready work.

## 1. Start the Jira ticket

1. Assign the Jira ticket to yourself.
2. Move it from **To Do** to **In Progress**.
3. Read its acceptance criteria before changing code.

## 2. Create a branch from main

Update `main`, then create one branch for the ticket:

```powershell
git switch main
git pull origin main
git switch -c SCRUM-XXX-short-ticket-name
```

Examples include `SCRUM-146-registration-api` and `SCRUM-176-login-error`. Use the Jira key at the start of every branch name.

## 3. Make, test, and commit the change

Keep the branch focused on the ticket. Review the changed files before committing, and never commit `.env`, passwords, real personal data, or generated IDE files.

```powershell
git status
git add <changed-files>
git commit -m "SCRUM-XXX describe the completed change"
git push -u origin SCRUM-XXX-short-ticket-name
```

Additional commits can be pushed to the same branch while the Merge Request is open.

## 4. Create the GitLab Merge Request

1. Open the [Campus Market project](https://gitlab.com/campus-market-team-3/campus-market) in GitLab.
2. Select **Merge requests > New merge request**.
3. Choose the ticket branch as the source and `main` as the target.
4. Use a title such as `SCRUM-146 Create user registration API`.
5. Explain what changed and how it was tested. Add screenshots for visible interface changes.
6. Select at least one teammate as a reviewer. Do not use only the author as the reviewer.
7. Create it as a draft if work remains. When it is complete, mark it ready and move the Jira ticket to **In Review**.

## 5. Review and merge

The reviewer checks the ticket acceptance criteria, reads the diff, runs relevant checks, and leaves comments or approves the Merge Request. If changes are requested, the author updates the same branch and pushes again.

After at least one teammate approves and all checks pass:

1. Merge the Merge Request into `main`.
2. Delete the source branch when GitLab offers the option.
3. Move the Jira ticket to **Done** only after its acceptance criteria are met.
4. Update the local copy before starting another ticket with `git switch main` and `git pull origin main`.

## PhpStorm

Add the GitLab account under **File > Settings > Version Control > GitLab**. PhpStorm can then show Merge Requests, diffs, comments, reviewers, and approvals in its GitLab tool window. The **Commit** tool window is used to review and commit local changes; **Push** publishes the branch to GitLab.

## Jira setup

Configure Backlog, To Do, In Progress, Testing/Review, and Done. If the board uses a separate backlog view rather than a Backlog status, document that choice with the team. Ensure Done maps to the completed status category.

## GitLab project checklist

- Add the project manager as Owner or Maintainer and each coding teammate as Developer.
- Add the professor as Reporter when read-only repository access is needed.
- Protect `main`, require Merge Requests, require at least one approval, and block force pushes.
- Add required automated checks after the actual build/test workflow exists.
- Store deployment secrets in GitLab CI/CD variables, never in tracked files.

The ignore file reduces accidental staging of common secret files. It does not stop force-adding a file or putting a secret inside source code; review every staged diff.
