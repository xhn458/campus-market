# Live website deployment

Campus Market is prepared for deployment as a Render web service. Render builds the PHP Docker image from GitLab, gives the site an HTTPS `onrender.com` address, and automatically deploys changes pushed to `main`.

The live PHP site connects to the existing Aiven MySQL service:

- Host: `campus-market-mysql-campus-market-team-3.l.aivencloud.com`
- Port: `24639`
- Database: `campus_market`
- Application user: `campus_market_app`

`defaultdb` is the name shown on the original Aiven connection. The project tables are stored in the separate `campus_market` database on that same server.

## Create the Render service

1. Sign in at <https://dashboard.render.com> using GitLab.
2. Select **New > Blueprint**.
3. Connect the `campus-market-team-3/campus-market` GitLab project.
4. Select the `main` branch and `render.yaml` Blueprint.
5. Enter the private `campus_market_app` password when Render requests `DB_PASSWORD`.
6. Create the Blueprint and wait for the first build.

## Add the Aiven CA certificate

The application verifies Aiven's TLS certificate. In the new Render service:

1. Open **Environment**.
2. Under **Secret Files**, select **Add Secret File**.
3. Set the filename to `ca.pem`.
4. Paste the complete contents of the CA certificate downloaded from Aiven.
5. Save and deploy the service.

Render mounts this file at `/etc/secrets/ca.pem`, matching `DB_SSL_CA` in `render.yaml`. Never commit the database password or CA file.

## Verify the deployment

Open the service's generated URL, then open `/api/health`. A working deployment returns:

```json
{
    "status": "ok",
    "application": "Campus Market",
    "database": "connected"
}
```

The Free web service can sleep after inactivity, so the first request after a pause can take about a minute. Local development remains at <http://localhost:8000> and continues using the ignored `.env` file.

