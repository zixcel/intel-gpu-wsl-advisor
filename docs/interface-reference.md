# intel-gpu-wsl-advisor interface reference

Use the [usage guide](getting-started.md) for the first steps. This reference preserves the current interface details and operational limits. Run command examples from the repository root, after preparing the exact declared dependencies and registered configuration.

## Compatibility inputs

The bundled `Hardware/supported_hardware_table.tsv` is a historical snapshot, not a current compatibility guarantee. Verify the detected PCI ID against [Intel's supported hardware documentation](https://dgpu-docs.intel.com/overview/supported-hardware/i915-driver-gpus.html) and the selected runtime's requirements. Kernel versions are compared as structured versions, rather than decimal numbers.

The script suggests Ubuntu 24.04 for a listed minimum kernel of 6.8 or later, or Ubuntu 22.04 for 5.15 through 6.7. Older or unrecognized requirements require manual review. Confirm the actual WSL kernel, Windows GPU driver and Linux runtime separately: selecting a distribution does not guarantee GPU support. See [Intel's installation guidance](https://dgpu-docs.intel.com/driver/client/overview.html) and [Intel's WSL prerequisites](https://www.intel.com/content/www/us/en/developer/articles/tool/pytorch-prerequisites-for-intel-gpu/2-5.html). Distribution installation must use a name listed by `wsl --list --online`.

[devino](https://github.com/zixcel/devino) can use this advice when preparing an experimental model-conversion environment. Application composition is owned by the caller.

## Validation

Migration checks inspect source, licensing, and references. Windows hardware detection and WSL installation require a Windows test environment and were not executed on the Linux migration host.
