param([Parameter(Mandatory = $true)][string]$pciID)
if ($pciID -notmatch '^[0-9A-Fa-f]{4}$') { throw 'PCI device ID must contain four hexadecimal digits.' }
$table = Import-Csv -LiteralPath (Join-Path $PSScriptRoot 'supported_hardware_table.tsv') -Delimiter "`t"
$entries = @($table | Where-Object { @($_.'PCI IDs' -split ',\s*') -contains $pciID })
if ($entries.Count -ne 1) { throw 'The historical hardware table must contain exactly one matching entry.' }
$entries[0]
