# Shared MySQL setup

The team uses one hosted Aiven for MySQL service as the shared development database. Local MySQL remains available for offline work and isolated testing.

## Project manager: create the service once

1. Sign in to the [Aiven Console](https://console.aiven.io/).
2. Create a project named `campus-market-team-3`.
3. Select **Create service**, choose **MySQL**, and select the **Free** plan.
4. Name the service `campus-market-mysql` and create it. Aiven chooses the cloud and region for the free plan.
5. Open the service, select **Databases**, and use the existing `defaultdb` database.
6. Select **Users** and add a service user named `campus_market_app`.
7. On the service Overview page, record the host, port, database, username, and generated password.
8. Download the CA certificate and save it locally as `certificates/aiven-ca.pem`.

The password and CA file must not be committed to GitLab, placed in Jira, or included in screenshots. Give the connection details only to current team members through a private channel. Rotate the password if it is exposed or when a member leaves the team.

## Project manager: load the schema once

From the project folder, replace the placeholders with the values shown by Aiven and run:

```powershell
mysql --host=YOUR_AIVEN_HOST --port=YOUR_AIVEN_PORT --user=campus_market_app --password --ssl-mode=VERIFY_CA --ssl-ca=certificates/aiven-ca.pem defaultdb < database/schema.sql
```

The command asks for the shared database password without displaying it. Run the schema again after approved database changes; its current statements are safe to repeat.

## Every teammate: connect the application

1. Download the same Aiven CA certificate into `certificates/aiven-ca.pem`.
2. Copy the shared environment template:

```powershell
Copy-Item .env.shared.example .env
```

3. Replace the placeholder host, port, username, and password in `.env` with the private Aiven values.
4. Start the application:

```powershell
.\scripts\start-app.ps1
```

5. Open <http://localhost:8000/api/health>. A successful connection returns `"database": "connected"`.

Each teammate still uses `localhost` for the PHP website. Only the `DB_HOST` points to Aiven because the database is remote.

## Connect with SQLyog

Create a new MySQL connection using the Aiven host, port, service username, password, and `defaultdb`. In the connection's SSL settings, enable SSL and select `certificates/aiven-ca.pem` as the CA certificate. Test the connection before saving it.

Use the application user for normal development. Keep the Aiven administrator credentials with the project manager for user management and recovery.

## Working safely with shared data

- Use test accounts and fake listings only; do not store real student information during development.
- Coordinate schema changes through Jira and a GitLab Merge Request before applying them.
- Export a backup before destructive schema or bulk-data changes.
- Keep a local database for experiments that might disrupt teammates.
