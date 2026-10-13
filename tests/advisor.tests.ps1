$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$script:passed = 0
function Check([bool]$condition, [string]$message) {
    if (-not $condition) { throw $message }
    $script:passed++
}
function Reject([scriptblock]$action, [string]$message) {
    $failed = $false
    try { & $action | Out-Null } catch { $failed = $true }
    Check $failed $message
}
$script:gpuData = @([pscustomobject]@{ Name = 'Synthetic Intel'; PNPDeviceID = 'PCI\VEN_8086&DEV_E20B&SUBSYS_00000000' })
function global:Get-CimInstance { param($ClassName) $script:gpuData }
$script:commands = @()
$script:wslExit = 0
$script:installed = @()
function global:wsl.exe {
    $script:commands += ,@($args)
    $global:LASTEXITCODE = $script:wslExit
    if ($args[0] -eq '--list') { $script:installed }
}
try {
    Check ((& "$repo/Hardware/PCIID.ps1" 'PCI\VEN_8086&DEV_e20b&SUBSYS_0') -eq 'E20B') 'PCI normalization failed'
    Reject { & "$repo/Hardware/PCIID.ps1" 'PCI\VEN_1234&DEV_E20B' } 'Foreign vendor accepted'
    Reject { & "$repo/Hardware/PCIID.ps1" 'VEN_8086&DEV_E20B7' } 'Oversized PCI ID accepted'
    Reject { & "$repo/Hardware/GPUTable.ps1" 'FFFF' } 'Unknown device accepted'
    Reject { & "$repo/Hardware/GPUTable.ps1" 'E20B;cmd' } 'Invalid table key accepted'
    Check ((& "$repo/Hardware/UbuntuVersion.ps1" '6.12*') -eq 'Ubuntu-24.04') 'Kernel minor comparison is decimal'
    Check ($null -eq (& "$repo/Hardware/UbuntuVersion.ps1" 'unknown')) 'Unknown kernel received a target'
    Push-Location ([System.IO.Path]::GetTempPath())
    try {
        $advice = & "$repo/WhichVersionInstall.ps1"
        Check ($advice.PciId -eq 'E20B') 'Caller directory affected data paths'
        Check (-not $advice.CompatibilityVerified) 'Historical advice claimed verification'
        Check ($script:commands.Count -eq 0) 'Read-only advice invoked WSL'
        & "$repo/WhichVersionInstall.ps1" -Install -WhatIf | Out-Null
        Check ($script:commands.Count -eq 0) 'WhatIf invoked WSL'
    } finally { Pop-Location }
    $script:gpuData += [pscustomobject]@{ Name = 'Second synthetic'; PNPDeviceID = 'PCI\VEN_8086&DEV_E20C' }
    Reject { & "$repo/Hardware/GPUInfo.ps1" } 'Ambiguous GPU selected implicitly'
    Check ((& "$repo/Hardware/GPUInfo.ps1" -DeviceId $script:gpuData[0].PNPDeviceID).Name -eq 'Synthetic Intel') 'Exact GPU selection failed'
    Reject { & "$repo/WSL/InstallWSLUbuntu.ps1" -version 'Ubuntu;other' -Confirm:$false } 'Unregistered distribution accepted'
    Check ($script:commands.Count -eq 0) 'Invalid target invoked WSL'
    & "$repo/WSL/InstallWSLUbuntu.ps1" -version 'Ubuntu-24.04' -WhatIf
    Check ($script:commands.Count -eq 0) 'Installer WhatIf invoked WSL'
    $script:installed = @("Ubuntu-24.04$([char]0)")
    & "$repo/WSL/InstallWSLUbuntu.ps1" -version 'Ubuntu-24.04' -Confirm:$false
    Check ($script:commands.Count -eq 1 -and $script:commands[0][0] -eq '--list') 'Existing distribution was installed twice'
    $script:commands = @(); $script:installed = @(); $script:wslExit = 1
    Reject { & "$repo/WSL/InstallWSLUbuntu.ps1" -version 'Ubuntu-24.04' -Confirm:$false } 'Failed discovery reported success'
    Check ($script:commands.Count -eq 1) 'Installation continued after failed discovery'
    $script:commands = @(); $script:wslExit = 0
    & "$repo/WSL/InstallWSLUbuntu.ps1" -version 'Ubuntu-22.04' -Confirm:$false
    Check (($script:commands[1] -join ' ') -eq '--install --distribution Ubuntu-22.04') 'Exact installation arguments differ'
    Write-Output "PASS: $script:passed synthetic advice/operation boundary assertions"
} finally {
    Remove-Item Function:\Get-CimInstance, Function:\wsl.exe
}
