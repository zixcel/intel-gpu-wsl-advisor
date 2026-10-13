[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param([Parameter(Mandatory = $true)][ValidateSet('Ubuntu-22.04', 'Ubuntu-24.04')][string]$version)
$ErrorActionPreference = 'Stop'
if (-not $PSCmdlet.ShouldProcess($version, 'Install a WSL distribution')) { return }
$installedDistros = @(wsl.exe --list --quiet)
if ($LASTEXITCODE -ne 0) { throw 'Unable to inspect installed WSL distributions.' }
$names = @($installedDistros | ForEach-Object { ([string]$_).Replace([string][char]0, '').Trim() })
if ($names -contains $version) { return }
wsl.exe --install --distribution $version
if ($LASTEXITCODE -ne 0) { throw 'WSL installation failed; success is not established.' }
