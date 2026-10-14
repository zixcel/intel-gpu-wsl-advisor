# Independent dependency updates

Install from the public registry using the repository manifest and lockfile. Dependabot proposes weekly manifest, lockfile and Action updates. Review and run this repository's CI before merging; major versions remain separate PRs. Update PRs replace duplicate update-tracking Issues. Do not use a neighboring checkout or a private artifact registry as the installation path.

A lockfile records one tested resolution and is updated by the PR. It does not require users to keep installing an obsolete version named in a README. Private Git dependencies still require an explicitly configured read-only route; Dependabot is not given a copied local credential. Toolchains remain declared by the repository.
