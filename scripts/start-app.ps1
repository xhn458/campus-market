$ErrorActionPreference = 'Stop'

$campusPhpCommand = Get-Command php -ErrorAction SilentlyContinue
$campusPhpExecutable = if ($campusPhpCommand) {
    $campusPhpCommand.Source
} else {
    'C:\Users\Gage Howard\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.4_Microsoft.Winget.Source_8wekyb3d8bbwe\php.exe'
}

if (-not (Test-Path -LiteralPath $campusPhpExecutable)) {
    throw 'PHP was not found. Install PHP 8.2 or newer and restart PhpStorm.'
}

$campusPhpDirectory = Split-Path -Parent $campusPhpExecutable
$campusExtensionDirectory = Join-Path $campusPhpDirectory 'ext'

& $campusPhpExecutable `
    -n `
    -d "extension_dir=$campusExtensionDirectory" `
    -d extension=pdo_mysql `
    -S localhost:8000 `
    -t public `
    public/router.php
