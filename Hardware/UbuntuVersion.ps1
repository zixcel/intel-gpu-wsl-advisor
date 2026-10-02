param ($kernelVersion)

# Compare major/minor components. Decimal comparison incorrectly orders 6.12 before 6.8.
if ([string]$kernelVersion -notmatch '^([0-9]+)\.([0-9]+)') {
    Write-Host "[WARNING] Unrecognized kernel requirement; consult current Intel WSL guidance."
    return $null
}
$minimumKernel = [version]("{0}.{1}" -f $Matches[1], $Matches[2])
if ($minimumKernel -ge [version]"6.8") {
    Write-Host "[INFO] Consider Ubuntu 24.04; verify the actual WSL kernel and runtime requirements."
    return "Ubuntu-24.04"
}
if ($minimumKernel -ge [version]"5.15") {
    Write-Host "[INFO] Consider Ubuntu 22.04; verify the Windows driver and selected runtime."
    return "Ubuntu-22.04"
}
Write-Host "[WARNING] No automatic recommendation for this historical kernel requirement."
return $null
