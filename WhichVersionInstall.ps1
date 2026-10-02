Write-Host "[INFO] Starting GPU detection and compatibility check..."

# Retrieve GPU information
$gpu = & .\Hardware\GPUInfo.ps1

# Extract PCI Device ID
$pciID = & .\Hardware\PCIID.ps1 -PNPDeviceID $gpu.PNPDeviceID

# Match GPU against the compatibility list
$matchedGPU = & .\Hardware\GPUTable.ps1 -pciID $pciID

# Display results
Write-Host "[INFO] Detected Intel GPU: $($gpu.Name)"
Write-Host "    [INFO] PCI Device ID: $pciID"
Write-Host "    [INFO] Matched GPU Model: $($matchedGPU.Name)"
Write-Host "    [INFO] Architecture: $($matchedGPU.Architecture)"
Write-Host "    [INFO] Codename: $($matchedGPU.Codename)"

# Extract and convert the kernel version
$kernelVersion = $matchedGPU.Kernel
Write-Host "    [INFO] Required Linux Kernel Version: $kernelVersion"
$ubuntuVersion = & .\Hardware\UbuntuVersion.ps1 -kernelVersion $kernelVersion

if ( -not $ubuntuVersion ) {
    Write-Host "[WARNING] No recommended Ubuntu WSL version found for this kernel version." -ForegroundColor Yellow
    Write-Host "[INFO] You can still manually choose a supported Ubuntu version for WSL installation."
    Write-Host "[INFO] Copy GPUs with supported drivers to Hardware\supported_hardware_table.tsv"
    Write-Host "[INFO]   refer https://dgpu-docs.intel.com/overview/supported-hardware/i915-driver-gpus.html"
    exit 0
}

# Ask user for Ubuntu version installation
Write-Host "Would you like to install Ubuntu WSL $ubuntuVersion now? (Y/N)" -ForegroundColor Yellow
$confirmInstall = Read-Host

if ($confirmInstall -match "^[Yy]$") {
    # Install WSL
    Write-Host "[INFO] Proceeding with WSL installation by Windows WSL."
    & .\WSL\InstallWSLUbuntu.ps1 -version $ubuntuVersion
} else {
    Write-Host "[INFO] WSL installation skipped. You can manually install it later using:"
    Write-Host "       wsl --install -d <Ubuntu-Version>" -ForegroundColor Yellow
}

Write-Host "[INFO] Environment advice complete."
