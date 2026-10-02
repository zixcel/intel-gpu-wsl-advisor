# Contributing

Discuss substantial API or architecture changes in an issue before implementation.
Keep changes focused, explain observable behavior, and include relevant tests and
validation evidence. Use the package's documented interfaces and versioned dependencies.
Application-specific composition belongs to callers.

Create a topic branch and open a pull request against main. Direct changes to main,
force pushes, and deleting main are restricted. Reviewers check correctness,
compatibility, licensing, security, and documentation. Resolve review conversations
before merging. Maintainers may request changes or decline a contribution.

Run the checks documented in README and the repository's security policy.
Do not commit credentials, customer or personal data, local registration/state,
production certificates or keys, generated archives, caches, or build outputs.
Use synthetic fixtures with documented provenance. Report vulnerabilities privately
as described in SECURITY.md. Passing the repository policy check does not replace
functional testing, secret inspection, or dependency analysis.

By submitting a contribution, you confirm that you are authorized to provide it
under the repository's applicable license. Preserve third-party notices and
existing permissions. Contributors retain their copyrights; submission does not
transfer ownership. Explain any new dependency and its license.

Follow CODE_OF_CONDUCT.md. Maintainers decide releases and compatibility policy;
a merged pull request does not itself promise a release or support commitment.
