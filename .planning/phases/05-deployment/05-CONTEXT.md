# Phase 5: Deployment - Context

**Gathered:** 2026-03-13
**Status:** Ready for planning

<domain>
## Phase Boundary

A self-contained publish script that packages the template for Typst Universe submission — sparse-clones a `typst/packages` fork, copies versioned files into the correct directory structure, generates a thumbnail, and commits on a release branch ready for a PR. The script should be easily copyable into other Typst package projects.

</domain>

<decisions>
## Implementation Decisions

### Script language & invocation
- Bash script wrapped in a Makefile at project root
- Multiple utility targets: `make publish` (full workflow), `make thumbnail` (generate only), `make clean` (remove artifacts)
- Non-interactive — runs without prompts, user reviews result in fork repo before manually creating the PR

### Fork & branch strategy
- Assume the user's fork of `typst/packages` already exists (no auto-creation via gh CLI)
- Sparse checkout into a temporary directory (mktemp) — no leftover state in the project, script prints the path
- Branch naming: `{name}-{version}` (e.g., `misq-0.1.0`)
- Script pushes the branch to the fork remote after committing — branch is ready for PR creation

### Thumbnail generation
- Use `typst compile --format png` natively — first page of `template/main.typ`, no extra tools needed
- `thumbnail.png` lives at project root (matches `typst.toml` declaration: `[template] thumbnail = "thumbnail.png"`)
- Committed to the repo and versioned alongside the template
- `make publish` auto-regenerates thumbnail from latest template before publishing (ensures it matches current state)
- Must meet Typst Universe constraints: >= 1080px longer edge, <= 3 MiB

### Portability design
- Config variables at the top of the Makefile: `PKG_NAME`, `PKG_VERSION`, `GITHUB_USER`, etc. — change 3-4 lines to reuse in another project
- Hardcoded file include list (misq.typ, apa.csl, typst.toml, thumbnail.png, template/*, LICENSE) — only listed files are copied, everything else implicitly excluded
- Include list is sufficient — no explicit excludes needed
- Version bumps are manual: user updates `typst.toml` before running `make publish`, script reads the current version

### Claude's Discretion
- Exact Makefile structure and target dependencies
- Sparse checkout git commands and cleanup
- Commit message format for the packages fork commit
- Error handling (missing typst CLI, missing fork, etc.)
- Whether `make clean` removes the temp clone dir or just local artifacts

</decisions>

<specifics>
## Specific Ideas

- GitHub remote is `rschuetzler/magnificent-misq` — fork username for packages repo is `rschuetzler`
- Typst Universe package directory structure: `packages/preview/{name}/{version}/`
- The ambivalent-amcis project has no publish script — this will be the first, designed to be copied back to amcis later
- `typst.toml` already declares `thumbnail = "thumbnail.png"` but the file doesn't exist yet

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `typst.toml`: Already has complete package metadata (name, version, entrypoint, template path, thumbnail declaration)
- `template/main.typ`: Source for thumbnail generation (first page)
- Package files at root: `misq.typ`, `apa.csl`, `typst.toml`
- Template files: `template/main.typ`, `template/references.bib`

### Established Patterns
- Package follows ambivalent-amcis structure: root entrypoint + template/ folder
- No existing build/publish automation in either project

### Integration Points
- Makefile at project root — new file, no conflicts
- `thumbnail.png` at project root — new file, already declared in typst.toml
- `typst.toml` read for version info but not modified by script

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 05-deployment*
*Context gathered: 2026-03-13*
