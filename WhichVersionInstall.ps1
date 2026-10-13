[CmdletBinding(SupportsShouldProcess = $true)]
param([switch]$Install, [string]$DeviceId)
$ErrorActionPreference = 'Stop'

# Detection/advice is read-only. Installation requires both an explicit switch
# and normal PowerShell ShouldProcess approval; -WhatIf performs no WSL command.
$gpu = & (Join-Path $PSScriptRoot 'Hardware/GPUInfo.ps1') -DeviceId $DeviceId
$pciID = & (Join-Path $PSScriptRoot 'Hardware/PCIID.ps1') -PNPDeviceID $gpu.PNPDeviceID
$matchedGPU = & (Join-Path $PSScriptRoot 'Hardware/GPUTable.ps1') -pciID $pciID
$ubuntuVersion = & (Join-Path $PSScriptRoot 'Hardware/UbuntuVersion.ps1') -kernelVersion $matchedGPU.Kernel
$advice = [pscustomobject]@{
    Name = $gpu.Name; DeviceId = $gpu.PNPDeviceID; PciId = $pciID
    HistoricalModel = $matchedGPU.Name; MinimumKernel = $matchedGPU.Kernel
    SuggestedDistribution = $ubuntuVersion
    CompatibilityVerified = $false
}
$advice
if ($Install) {
    if (-not $ubuntuVersion) { throw 'No installation target is defined for this historical entry.' }
    if ($PSCmdlet.ShouldProcess($ubuntuVersion, 'Install a WSL distribution')) {
        & (Join-Path $PSScriptRoot 'WSL/InstallWSLUbuntu.ps1') -version $ubuntuVersion -Confirm:$false
    }
}
