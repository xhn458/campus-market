# Shared MySQL setup

The team uses one hosted Aiven for MySQL service as the shared development database. Local MySQL remains available for feature work, experiments, and offline development.

## Existing shared service

- Aiven project: `campus-market-team-3`
- Service: `campus-market-mysql`
- Host: `campus-market-mysql-campus-market-team-3.l.aivencloud.com`
- Port: `24639`
- Database: `campus_market`
- Application user: `campus_market_app`

Each teammate must get the generated application password through a private channel and download the CA certificate from the service Overview page. Save the certificate as `certificates/ca.pem`.

The password and CA file must not be committed to GitLab, placed in Jira, or included in screenshots. Rotate the password if it is exposed or when a member leaves the team.

## Project manager: load the schema once

From the project folder, replace the placeholders with the values shown by Aiven and run:

```powershell
mysql --host=campus-market-mysql-campus-market-team-3.l.aivencloud.com --port=24639 --user=campus_market_app --password --ssl-mode=VERIFY_CA --ssl-ca=certificates/ca.pem --execute="source database/schema.sql" campus_market
```

The command asks for the shared database password without displaying it. Run the schema again after approved database changes; its current statements are safe to repeat.

## Every teammate: create two private environments

1. Download the same Aiven CA certificate into `certificates/ca.pem`.
2. Create one local profile and one shared profile:

```powershell
Copy-Item .env.example .env.local
Copy-Item .env.shared.example .env.shared
```

3. Put the developer's local MySQL settings in `.env.local`.
4. Put the Aiven host, port, username, password, and certificate path in `.env.shared`.

Both files are ignored by Git. Never commit either file.

## Switch between local and shared MySQL

Use the shared server when checking integrated team data:

```powershell
.\scripts\use-database.ps1 shared
```

Use local MySQL while developing or testing changes:

```powershell
.\scripts\use-database.ps1 local
```

The command copies the selected private profile to the active `.env` file. `APP_ENV=local` or `APP_ENV=shared` describes the selected environment, but the `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, and `DB_PASSWORD` values determine which database PHP actually connects to.

Restart the PHP server after switching, then open <http://localhost:8000/api/health>. A successful connection returns `"database": "connected"`.

## Refresh local MySQL from the shared server

Run the included refresh command:

```powershell
.\scripts\sync-shared-to-local.ps1
```

Type `COPY` when prompted, then enter the Aiven application password. The script uses `.env.shared` when present or the committed shared template otherwise. It uses `.env.local` when present or the active local `.env` otherwise. It downloads all structure and data from Aiven, replaces the local `campus_market` database, verifies the result, and removes its temporary dump. Passwords are not displayed or placed in command history.

For an automated refresh without the prompt, use:

```powershell
.\scripts\sync-shared-to-local.ps1 -Force
```

Refreshing replaces the complete local database. Teammates should never experiment directly against the shared database.

Start the application after selecting the desired environment:

```powershell
.\scripts\start-app.ps1
```

Each teammate still uses `localhost` for the PHP website. Only the `DB_HOST` points to Aiven because the database is remote.

## Connect with SQLyog

Create a new MySQL connection using the Aiven host, port, service username, password, and `campus_market`. In the connection's SSL settings, enable SSL and select `certificates/ca.pem` as the CA certificate. Test the connection before saving it.

Use the application user for normal development. Keep the Aiven administrator credentials with the project manager for user management and recovery.

## Working safely with shared data

- Use test accounts and fake listings only; do not store real student information during development.
- Coordinate schema changes through Jira and a GitLab Merge Request before applying them.
- Export a backup before destructive schema or bulk-data changes.
- Keep a local database for experiments that might disrupt teammates.
