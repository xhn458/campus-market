# Technical decisions

These are the initial technology decisions selected for Campus Market. The team should record formal agreement in Jira before closing the related tickets.

| Ticket | Decision | Suggested decision owners | Status |
| --- | --- | --- | --- |
| SCRUM-133 | HTML, CSS, and browser JavaScript; no frontend framework initially | Emmelly / Jereme | Selected 2026-09-13 |
| SCRUM-134 | PHP 8.2+; framework-free initial structure | Chase / Jereme | Selected 2026-09-13 |
| SCRUM-135 | MySQL 8.0+ using PDO; local installation method pending | Ryan | Selected 2026-09-13 |
| SCRUM-130 | GitLab `main`/ticket-branch/Merge Request workflow | Jereme / Christina | Documented in WORKFLOW.md |
| SCRUM-178 | Hosting approach | Jereme | Pending |

The initial stack minimizes tooling and keeps HTML, CSS, JavaScript, PHP, and SQL visible to the team. A framework can be proposed later through a documented team decision if the project grows beyond this structure.

Next, define how frontend requests reach the backend, how authentication works, and how university email verification is tested. These choices affect SCRUM-138 and SCRUM-145 through SCRUM-152.
