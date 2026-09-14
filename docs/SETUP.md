# Local development setup

## Requirements

- PhpStorm
- PHP 8.2 or newer with the `pdo_mysql` extension
- MySQL 8.0 or newer
- Git
- Access to the [Campus Market GitLab project](https://gitlab.com/campus-market-team-3/campus-market)

PHP and MySQL are not bundled with PhpStorm. Each developer must install them and point PhpStorm at the PHP executable under **Settings > PHP**.

## Download the project with PhpStorm

1. Accept the GitLab project invitation.
2. Open PhpStorm and choose **File > New > Project from Version Control**.
3. Select Git and enter `https://gitlab.com/campus-market-team-3/campus-market.git`.
4. Choose where to save the project and click **Clone**.
5. Sign in to GitLab if PhpStorm asks, then trust and open the project.

Cloning keeps the full Git history and lets you create branches and Merge Requests. Avoid downloading the ZIP when you plan to contribute code.

## Download the project from a terminal

The equivalent terminal commands are:

```powershell
git clone https://gitlab.com/campus-market-team-3/campus-market.git
cd campus-market
```

## First-time local setup

Create a private environment file:

```powershell
Copy-Item .env.example .env
```

Edit `.env` with the local MySQL username and password. The file is ignored by Git.

Create the database and a limited local application user from a MySQL administrator session:

```sql
CREATE DATABASE campus_market CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'campus_market_app'@'localhost' IDENTIFIED BY 'choose-a-local-password';
GRANT ALL PRIVILEGES ON campus_market.* TO 'campus_market_app'@'localhost';
FLUSH PRIVILEGES;
```

Import the schema:

```powershell
mysql -u campus_market_app -p campus_market < database/schema.sql
```

Start the application from PhpStorm's terminal:

```powershell
.\scripts\start-app.ps1
```

Open <http://localhost:8000>. The page should report that the database is connected. The JSON health check is available at <http://localhost:8000/api/health>.

The start script locates PHP and enables the `pdo_mysql` driver for the local server. Restart PhpStorm after installing PHP so its terminal receives the updated PATH.

## PhpStorm configuration

1. Open the `campus-market` repository folder.
2. Go to **File > Settings > PHP**.
3. Add your installed PHP executable as the CLI interpreter.
4. Confirm PhpStorm displays PHP 8.2 or newer and the `pdo_mysql` extension.
5. Open the built-in terminal and run the start command above.

## Other team members

Before starting a Jira ticket, create a ticket branch from the latest `main`:

```powershell
git switch main
git pull origin main
git switch -c SCRUM-XXX-short-ticket-name
```

After making and testing the change, commit it, push the branch, and open a GitLab Merge Request:

```powershell
git add <changed-files>
git commit -m "SCRUM-XXX describe the completed change"
git push -u origin SCRUM-XXX-short-ticket-name
```

In GitLab, create a Merge Request from the ticket branch into `main`, complete the description, and request at least one teammate as a reviewer. Follow [the GitLab and Jira workflow](WORKFLOW.md) for the review and merge steps.

## Before SCRUM-136 and SCRUM-137 are done

- A successful setup confirmation from each of the five team members.
- Any operating-system-specific PHP and MySQL installation notes the team needed.
