param(
    [switch]$Force,
    [securestring]$SharedPassword
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$sharedEnvPath = Join-Path $projectRoot '.env.shared'
$sharedExamplePath = Join-Path $projectRoot '.env.shared.example'
$localEnvPath = Join-Path $projectRoot '.env.local'
$activeEnvPath = Join-Path $projectRoot '.env'

function Read-EnvFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    $values = @{}
    foreach ($line in Get-Content -LiteralPath $Path) {
        if ($line -match '^\s*([^#=]+)=(.*)$') {
            $values[$matches[1].Trim()] = $matches[2].Trim()
        }
    }

    return $values
}

function Find-MySqlTool {
    param([Parameter(Mandatory = $true)][string]$Name)

    $command = Get-Command "$Name.exe" -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    $candidates = @(
        "C:\Program Files\MySQL\MySQL Server 8.4\bin\$Name.exe",
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\$Name.exe",
        "C:\Program Files\MySQL\MySQL Workbench 8.0\$Name.exe"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    throw "$Name.exe was not found. Install MySQL Server or MySQL Workbench and try again."
}

function Require-EnvValue {
    param(
        [Parameter(Mandatory = $true)][hashtable]$Values,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Profile
    )

    $value = $Values[$Name]
    if ([string]::IsNullOrWhiteSpace($value)) {
        throw "$Name is missing from $Profile."
    }

    return $value
}

$sharedProfilePath = if (
    (Test-Path -LiteralPath $sharedEnvPath) -and
    ((Get-Content -LiteralPath $sharedEnvPath -Raw) -match '(?m)^DB_HOST=')
) { $sharedEnvPath } else { $sharedExamplePath }

$localProfilePath = if (
    (Test-Path -LiteralPath $localEnvPath) -and
    ((Get-Content -LiteralPath $localEnvPath -Raw) -match '(?m)^DB_HOST=')
) { $localEnvPath } else { $activeEnvPath }

$shared = Read-EnvFile -Path $sharedProfilePath
$local = Read-EnvFile -Path $localProfilePath

$sharedHost = Require-EnvValue $shared 'DB_HOST' '.env.shared'
$sharedPort = Require-EnvValue $shared 'DB_PORT' '.env.shared'
$sharedDatabase = Require-EnvValue $shared 'DB_DATABASE' '.env.shared'
$sharedUser = Require-EnvValue $shared 'DB_USERNAME' '.env.shared'
$sharedCaSetting = Require-EnvValue $shared 'DB_SSL_CA' '.env.shared'

$localHost = Require-EnvValue $local 'DB_HOST' '.env.local'
$localPort = Require-EnvValue $local 'DB_PORT' '.env.local'
$localDatabase = Require-EnvValue $local 'DB_DATABASE' '.env.local'
$localUser = Require-EnvValue $local 'DB_USERNAME' '.env.local'
$localPassword = Require-EnvValue $local 'DB_PASSWORD' '.env.local'

$sharedPasswordText = $shared['DB_PASSWORD']
if ($SharedPassword) {
    $sharedPasswordText = [System.Net.NetworkCredential]::new('', $SharedPassword).Password
} elseif ([string]::IsNullOrWhiteSpace($sharedPasswordText) -or $sharedPasswordText -like 'replace_*') {
    $passwordPrompt = Read-Host 'Aiven campus_market_app password' -AsSecureString
    $sharedPasswordText = [System.Net.NetworkCredential]::new('', $passwordPrompt).Password
}

if ([string]::IsNullOrWhiteSpace($sharedPasswordText)) {
    throw 'The shared database password cannot be empty.'
}

if ($sharedDatabase -ne $localDatabase) {
    throw "The shared database ($sharedDatabase) and local database ($localDatabase) must have the same name."
}

$caPath = if ([System.IO.Path]::IsPathRooted($sharedCaSetting)) {
    $sharedCaSetting
} else {
    Join-Path $projectRoot $sharedCaSetting
}

if (-not (Test-Path -LiteralPath $caPath)) {
    throw "Aiven CA certificate not found at $caPath."
}

if (-not $Force) {
    $answer = Read-Host "This replaces local database '$localDatabase' with the shared Aiven copy. Type COPY to continue"
    if ($answer -cne 'COPY') {
        Write-Host 'Copy cancelled. The local database was not changed.'
        exit 0
    }
}

$mysql = Find-MySqlTool -Name 'mysql'
$mysqldump = Find-MySqlTool -Name 'mysqldump'
$dumpPath = Join-Path ([System.IO.Path]::GetTempPath()) "campus-market-$([guid]::NewGuid().ToString('N')).sql"
$previousMySqlPassword = $env:MYSQL_PWD

try {
    Write-Host "Exporting $sharedDatabase from Aiven..."
    $env:MYSQL_PWD = $sharedPasswordText
    & $mysqldump `
        "--host=$sharedHost" `
        "--port=$sharedPort" `
        "--user=$sharedUser" `
        '--ssl-mode=VERIFY_CA' `
        "--ssl-ca=$caPath" `
        '--single-transaction' `
        '--routines' `
        '--triggers' `
        '--events' `
        '--set-gtid-purged=OFF' `
        '--no-tablespaces' `
        '--add-drop-database' `
        '--databases' $sharedDatabase `
        "--result-file=$dumpPath"

    if ($LASTEXITCODE -ne 0) {
        throw "The shared database export failed with exit code $LASTEXITCODE."
    }

    Write-Host "Replacing local database $localDatabase..."
    $env:MYSQL_PWD = $localPassword
    $mysqlSourcePath = $dumpPath.Replace('\', '/')
    & $mysql `
        "--host=$localHost" `
        "--port=$localPort" `
        "--user=$localUser" `
        "--execute=SOURCE $mysqlSourcePath"

    if ($LASTEXITCODE -ne 0) {
        throw "The local database import failed with exit code $LASTEXITCODE."
    }

    & $mysql `
        "--host=$localHost" `
        "--port=$localPort" `
        "--user=$localUser" `
        "--database=$localDatabase" `
        '--batch' `
        '--skip-column-names' `
        "--execute=SELECT CONCAT(COUNT(*), ' tables copied') FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE();"

    if ($LASTEXITCODE -ne 0) {
        throw "The local database verification failed with exit code $LASTEXITCODE."
    }

    Write-Host 'Shared database copied to local MySQL successfully.'
} finally {
    $env:MYSQL_PWD = $previousMySqlPassword
    if (Test-Path -LiteralPath $dumpPath) {
        [System.IO.File]::Delete($dumpPath)
    }
}
