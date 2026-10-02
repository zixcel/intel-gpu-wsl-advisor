param ($version)

Write-Host "[INFO] Verifying WSL $version installation requirements..."

if (-not $version) {
    Write-Host "[ERROR] No Ubuntu version specified. Please provide a version (e.g., Ubuntu-22.04 or Ubuntu-24.04). Exiting." -ForegroundColor Red
    exit 1
}

# Check existing WSL distributions
$installedDistros = wsl --list --quiet

if ($installedDistros -match "^$version$") {
    Write-Host "[INFO] Ubuntu $version is already installed in WSL. No action needed." -ForegroundColor Cyan
    exit 0
}

Write-Host "[INFO] Installing Ubuntu $version in WSL..."
wsl --install --distribution $version

# Output same log by WSL
#Write-Host "[SUCCESS] Installation complete!" -ForegroundColor Green
#Write-Host "[INFO] To launch WSL, run the following command:" -ForegroundColor Yellow
#Write-Host "       wsl -d $version" -ForegroundColor Yellow
