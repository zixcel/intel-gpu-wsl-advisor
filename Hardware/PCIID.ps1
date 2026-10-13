param([Parameter(Mandatory = $true)][string]$PNPDeviceID)
if ($PNPDeviceID -notmatch '(?i)(?:^|[\\&])VEN_8086&DEV_([0-9A-F]{4})(?:&|$)') {
    throw 'A valid Intel PCI device identity is required.'
}
$Matches[1].ToUpperInvariant()
