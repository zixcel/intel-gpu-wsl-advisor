param([string]$DeviceId)
$ErrorActionPreference = 'Stop'
$gpuList = @(Get-CimInstance -ClassName Win32_VideoController | Where-Object {
    $_.PNPDeviceID -match '(?i)VEN_8086&DEV_[0-9A-F]{4}'
})
if ($DeviceId) { $gpuList = @($gpuList | Where-Object { $_.PNPDeviceID -eq $DeviceId }) }
if ($gpuList.Count -ne 1) {
    throw 'Select exactly one detected Intel GPU with -DeviceId; no device is selected implicitly.'
}
$gpuList[0]
