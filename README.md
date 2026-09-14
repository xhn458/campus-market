# Campus Market

Campus Market is a student-focused marketplace being developed for CPSC 4910 Senior Capstone.

The application will allow verified college students to buy, sell, and trade items with other students in their campus community.

## Team 3

- Jereme Howard - Project Manager / Full-Stack Developer
- Chase Berry - Backend/API Developer
- Emmelly Jackson - Frontend/UI Developer
- Ryan Leun - Database & Security Developer
- Christina Dawood - Testing & DevOps Developer

## Project Status

Beta / In Development

## Course

CPSC 4910 - Senior Capstone
Fall 2026
University of Tennessee at Chattanooga

## Development setup

Campus Market uses HTML, CSS, and JavaScript on the frontend, PHP on the backend, and MySQL for persistent data. It starts without a framework so the team can learn and divide the application clearly.

Clone the project from [GitLab](https://gitlab.com/campus-market-team-3/campus-market), open the repository folder in PhpStorm, and follow the local setup guide. The starter includes a homepage, a JSON health endpoint, environment configuration, a PDO database connection, and the initial schema.

- [Project structure and starter overview](README.starter.md)
- [Local setup guide](docs/SETUP.md)
- [Shared MySQL setup](docs/SHARED-DATABASE.md)
- [GitLab and Jira workflow](docs/WORKFLOW.md)
- [Sprint 1 kickoff checklist](docs/SPRINT-1.md)
- [Technical decisions](docs/DECISIONS.md)

## Quick start

After installing PHP 8.2 or newer and creating `.env` from `.env.example`:

```powershell
.\scripts\start-app.ps1
```

Open <http://localhost:8000>. Check the backend and database at <http://localhost:8000/api/health>.
