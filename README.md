# intel-gpu-wsl-advisor

Check an Intel GPU and WSL environment and see which setup requirements need attention.

## What you can do

- Inspect the declared Windows/WSL environment checks.
- Review compatibility guidance before changing the machine.

## Current scope

Compatibility guidance depends on detected hardware and reviewed tool versions. Installation or host changes must remain explicit operator actions.

Package distribution is not activated by this documentation. Use the checked-in source and the declared dependency versions; published availability must be verified separately.

## Getting started

Start with the implementation and examples linked below. Review registered configuration and prerequisites before running a command that writes state or contacts a service.

## Check your environment

Run from a Windows PowerShell terminal after reviewing the script:

```powershell
.\WhichVersionInstall.ps1
```

GPU detection requires Windows. The script offers WSL Ubuntu installation only after an interactive confirmation; installation may require administrator rights. The bundled hardware table is historical guidance. Check the actual Windows driver, WSL kernel and selected runtime before relying on a recommendation.

## Documentation and source

[Interface reference](docs/interface-reference.md)

[Usage guide](docs/getting-started.md)

[Contributing](CONTRIBUTING.md) · [Security reporting](SECURITY.md) · [License](LICENSE) · [Attribution notices](NOTICE)
