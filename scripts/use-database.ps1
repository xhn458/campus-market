param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('local', 'shared')]
    [string]$Target
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $projectRoot ".env.$Target"
$destination = Join-Path $projectRoot '.env'

if (-not (Test-Path -LiteralPath $source)) {
    throw "Missing .env.$Target. Create it from the matching example and add your private database settings."
}

Copy-Item -LiteralPath $source -Destination $destination -Force
Write-Host "Campus Market now uses the $Target database settings from .env.$Target."
