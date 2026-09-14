# Shared MySQL setup

The team uses one hosted Aiven for MySQL service as the shared development database. Local MySQL remains available for feature work, experiments, and offline development.

## Existing shared service

- Aiven project: `campus-market-team-3`
- Service: `campus-market-mysql`
- Host: `campus-market-mysql-campus-market-team-3.l.aivencloud.com`
- Port: `24639`
- Database: `defaultdb`
- Application user: `campus_market_app`

Each teammate must get the generated application password through a private channel and download the CA certificate from the service Overview page. Save the certificate as `certificates/aiven-ca.pem`.

The password and CA file must not be committed to GitLab, placed in Jira, or included in screenshots. Rotate the password if it is exposed or when a member leaves the team.

## Project manager: load the schema once

From the project folder, replace the placeholders with the values shown by Aiven and run:

```powershell
mysql --host=campus-market-mysql-campus-market-team-3.l.aivencloud.com --port=24639 --user=campus_market_app --password --ssl-mode=VERIFY_CA --ssl-ca=certificates/aiven-ca.pem --execute="source database/schema.sql" defaultdb
```

The command asks for the shared database password without displaying it. Run the schema again after approved database changes; its current statements are safe to repeat.

## Every teammate: create two private environments

1. Download the same Aiven CA certificate into `certificates/aiven-ca.pem`.
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

First export the shared database into an ignored temporary file:

```powershell
mysqldump --host=campus-market-mysql-campus-market-team-3.l.aivencloud.com --port=24639 --user=campus_market_app --password --ssl-mode=VERIFY_CA --ssl-ca=certificates/aiven-ca.pem --single-transaction --result-file=database/shared-copy.local.sql defaultdb
```

Then import that copy into the developer's local `campus_market` database:

```powershell
mysql --host=127.0.0.1 --port=3306 --user=campus_market_app --password --execute="source database/shared-copy.local.sql" campus_market
```

These commands prompt separately for the shared and local passwords. The dump is ignored by Git and should be deleted when it is no longer needed. Refreshing replaces or updates local test data only; teammates should never experiment directly against the shared database.

Start the application after selecting the desired environment:

```powershell
.\scripts\start-app.ps1
```

Each teammate still uses `localhost` for the PHP website. Only the `DB_HOST` points to Aiven because the database is remote.

## Connect with SQLyog

Create a new MySQL connection using the Aiven host, port, service username, password, and `defaultdb`. In the connection's SSL settings, enable SSL and select `certificates/aiven-ca.pem` as the CA certificate. Test the connection before saving it.

Use the application user for normal development. Keep the Aiven administrator credentials with the project manager for user management and recovery.

## Working safely with shared data

- Use test accounts and fake listings only; do not store real student information during development.
- Coordinate schema changes through Jira and a GitLab Merge Request before applying them.
- Export a backup before destructive schema or bulk-data changes.
- Keep a local database for experiments that might disrupt teammates.
