# Local development setup

## Requirements

- PhpStorm
- PHP 8.2 or newer with the `pdo_mysql` extension
- MySQL 8.0 or newer
- Git

PHP and MySQL are not bundled with PhpStorm. Each developer must install them and point PhpStorm at the PHP executable under **Settings > PHP**.

## First-time setup

Clone the repository or open the existing local folder:

```powershell
git clone https://github.com/xhn458/campus-market.git
cd campus-market
```

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
3. Add the installed PHP executable as the CLI interpreter. On the current project computer it is located at `C:\Users\Gage Howard\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.4_Microsoft.Winget.Source_8wekyb3d8bbwe\php.exe`.
4. Confirm PhpStorm displays PHP 8.2 or newer and the `pdo_mysql` extension.
5. Open the built-in terminal and run the start command above.

## Other team members

Other team members should create a ticket branch from the latest `main`:

```powershell
git switch main
git pull
git switch -c SCRUM-XXX-short-ticket-name
```

## Before SCRUM-136 and SCRUM-137 are done

- A successful setup confirmation from each of the five team members.
- Any operating-system-specific PHP and MySQL installation notes the team needed.
