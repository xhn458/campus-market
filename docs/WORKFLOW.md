# Proposed Git and Jira workflow

Team agreement is required before SCRUM-130 is Done.

## Branches

- `main`: reviewed, demo-ready work.
- `dev`: integration branch for the current sprint.
- `feature/SCRUM-146-registration-api`: one ticket's work, branched from `dev`.
- `fix/SCRUM-176-login-error`: a specific bug fix, branched from `dev`.

Use the Jira ticket key in branch names, commit messages, and pull request titles.

## Completing a ticket

1. Assign the ticket and move it from To Do to In Progress.
2. Update `dev` and create a ticket branch.
3. Implement the ticket's acceptance criteria and relevant checks.
4. Open a pull request targeting `dev`; describe the behavior and how it was verified.
5. Move the ticket to Testing/Review and request a teammate's review.
6. Merge after review and checks pass; mark Done only when acceptance criteria are met.
7. Promote reviewed sprint work from `dev` to `main` for the demo.

## Jira setup

Configure Backlog, To Do, In Progress, Testing/Review, and Done. If the board uses a separate backlog view rather than a Backlog status, document that choice with the team. Ensure Done maps to the completed status category.

## GitHub setup checklist

- Invite all five team members and verify access.
- Create `main` and `dev` after the first commit.
- Where repository settings support it, require pull requests and one approval for `main` and `dev`, and disable force-pushing to those branches.
- Add required automated checks after the actual build/test workflow exists.
- Store deployment secrets in the relevant secret settings, never in tracked files.

The ignore file reduces accidental staging of common secret files. It does not stop force-adding a file or putting a secret inside source code; review every staged diff.
