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

GPU detection requires Windows. Advice is read-only by default. Use `-DeviceId` when multiple Intel GPUs are detected. Installation requires the explicit `-Install` switch and supports `-WhatIf`/`-Confirm`; it may require administrator rights. The bundled hardware table is historical guidance. Check the actual Windows driver, WSL kernel and selected runtime before relying on a recommendation.

## Documentation and source

[Interface reference](docs/interface-reference.md)

[Usage guide](docs/getting-started.md)

[Contributing](CONTRIBUTING.md) · [Security reporting](SECURITY.md) · [License](LICENSE) · [Attribution notices](NOTICE)

[OSS responsibility and source completion](docs/oss-source-contract.md) defines the supported package boundary and required acceptance. It does not declare unexecuted source, distribution or production checks complete.

## Source acceptance

Run `pwsh -File tests/advisor.tests.ps1`. Windows CI executes the same synthetic
hardware and WSL command tests. It checks caller-directory independence, exact PCI
identity, ambiguous/unknown devices, version ordering, read-only defaults, WhatIf,
existing distributions and failed discovery. No WSL installation or real GPU
compatibility is established by these tests. The historical table is advisory;
`CompatibilityVerified` remains false.

Dependency updates: [repository policy](docs/dependency-updates.md).
