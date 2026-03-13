# Phase 5: Deployment - Research

**Researched:** 2026-03-13
**Domain:** Bash/Makefile publish automation, Git sparse checkout, Typst PNG export, Typst Universe submission
**Confidence:** HIGH

## Summary

Phase 5 delivers a Makefile-based publish script that automates the Typst Universe submission workflow: generating a thumbnail PNG from the template, sparse-cloning the user's `typst/packages` fork into a temp directory, copying versioned package files into the correct directory structure, and committing a ready-to-PR branch. All decisions are locked from CONTEXT.md — the planner implements exactly what was decided.

The key technical areas are: (1) `typst compile --format png --ppi 250 --pages 1` for thumbnail generation meeting the 1080px requirement, (2) `git clone --filter=blob:none --sparse` + `git sparse-checkout set` for efficient partial clone, (3) `grep`/`sed` for extracting the version from `typst.toml`, and (4) a Makefile with config variables at top for portability. One pre-existing gap: **no README.md exists** in the project root — Typst Universe requires one; the publish script must either create it or the planner must add a task to create it first.

**Primary recommendation:** Implement as Makefile + embedded Bash logic. Use `--filter=blob:none --sparse` for the fork clone. Generate thumbnail at 250 PPI (yields ~2750px on Letter, well over 1080px). Extract version from typst.toml with sed. README.md creation is a prerequisite task.

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Script language & invocation:**
- Bash script wrapped in a Makefile at project root
- Multiple utility targets: `make publish` (full workflow), `make thumbnail` (generate only), `make clean` (remove artifacts)
- Non-interactive — runs without prompts, user reviews result in fork repo before manually creating the PR

**Fork & branch strategy:**
- Assume the user's fork of `typst/packages` already exists (no auto-creation via gh CLI)
- Sparse checkout into a temporary directory (mktemp) — no leftover state in the project, script prints the path
- Branch naming: `{name}-{version}` (e.g., `misq-0.1.0`)
- Script pushes the branch to the fork remote after committing — branch is ready for PR creation

**Thumbnail generation:**
- Use `typst compile --format png` natively — first page of `template/main.typ`, no extra tools needed
- `thumbnail.png` lives at project root (matches `typst.toml` declaration: `[template] thumbnail = "thumbnail.png"`)
- Committed to the repo and versioned alongside the template
- `make publish` auto-regenerates thumbnail from latest template before publishing (ensures it matches current state)
- Must meet Typst Universe constraints: >= 1080px longer edge, <= 3 MiB

**Portability design:**
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

### Deferred Ideas (OUT OF SCOPE)

None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| DEPLOY-01 | A publish script that copies package files to a local `typst/packages` fork, creates a versioned branch, and commits — ready for a PR | Git sparse checkout + cp commands + git commit sequence documented below |
| DEPLOY-02 | The publish script uses sparse checkout to avoid cloning the full `typst/packages` repo | `--filter=blob:none --sparse` + `git sparse-checkout set` pattern documented below |
| DEPLOY-03 | The publish script is self-contained and copyable into other Typst package projects with minimal config changes | Config variables block at top of Makefile pattern documented below |
| DEPLOY-04 | A `thumbnail.png` is generated from the template (first page, >= 1080px longer edge, <= 3 MiB) | `typst compile --format png --ppi 250 --pages 1` yields ~2750px on Letter; 250 PPI verified against official manifest recommendation |
</phase_requirements>

---

## Standard Stack

### Core

| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| GNU Make | system | Task runner wrapping bash logic | Locked decision; ubiquitous on macOS/Linux |
| Bash | system | Script language inside Makefile targets | Locked decision; no external deps |
| typst CLI | system | PNG thumbnail generation via `compile --format png` | Only tool needed; locked decision |
| git | >= 2.25 | Sparse checkout of packages fork | Cone mode requires git 2.25+; macOS ships 2.39+ |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| oxipng | any (optional) | Lossless PNG compression to stay under 3 MiB | Optional post-step if thumbnail exceeds size limit |
| mktemp | system | Create temp directory for sparse clone | Avoids polluting project directory |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Make | shell script | Makefile gives named targets and dependency graph; locked |
| sed for TOML parsing | toml-cli / stoml | External dep not worth adding for simple `version = "x.y.z"` extraction |
| oxipng | pngquant | oxipng is lossless; pngquant is lossy — Typst Universe prefers lossless |

**Installation:** No installation required — all tools are either built-in (make, bash, git, mktemp) or already installed (typst).

---

## Architecture Patterns

### Recommended Project Structure

```
typst-misq/
├── Makefile              # NEW: publish automation + utility targets
├── thumbnail.png         # NEW: generated by make thumbnail, committed
├── typst.toml            # EXISTS: read for PKG_VERSION extraction
├── misq.typ              # EXISTS: copied to packages fork
├── apa.csl               # EXISTS: copied to packages fork
├── README.md             # MISSING: required by Typst Universe — must be created
├── LICENSE               # EXISTS: copied to packages fork
└── template/
    ├── main.typ          # EXISTS: source for thumbnail; copied to fork
    └── references.bib    # EXISTS: copied to fork
```

### Pattern 1: Makefile Config Block

**What:** Variables at the top of the Makefile that users change to port to another project.
**When to use:** All Makefile targets reference these variables — never hardcode values inside targets.

```makefile
# Source: CONTEXT.md portability decision
# ============================================================
# Configuration — change these 4 lines for another project
# ============================================================
PKG_NAME    := misq
GITHUB_USER := rschuetzler
FORK_REPO   := https://github.com/$(GITHUB_USER)/typst-packages.git
FORK_REMOTE := origin

# Derived — do not edit
PKG_VERSION := $(shell grep '^version' typst.toml | sed 's/version = "\(.*\)"/\1/')
BRANCH_NAME := $(PKG_NAME)-$(PKG_VERSION)
PKG_DIR     := packages/preview/$(PKG_NAME)/$(PKG_VERSION)

# Files to copy into the packages fork (explicit include list)
PKG_FILES   := misq.typ apa.csl typst.toml thumbnail.png LICENSE README.md template/
```

### Pattern 2: Version Extraction from typst.toml

**What:** Parse version string from `typst.toml` using sed — no external TOML parser.
**When to use:** In Makefile shell expansion.

```bash
# Source: verified pattern for simple "key = value" TOML extraction
PKG_VERSION := $(shell grep '^version' typst.toml | sed 's/version = "\(.*\)"/\1/')
```

This works reliably for the `typst.toml` format which always writes `version = "0.1.0"` without whitespace variation.

### Pattern 3: Thumbnail Generation

**What:** Compile first page of template to PNG at 250 PPI.
**When to use:** `make thumbnail` target and as prerequisite of `make publish`.

```bash
# Source: typst CLI man page + manifest.md recommendation of 250 PPI
# US Letter at 250 PPI = 2125 x 2750 px (longer edge 2750 > 1080 requirement)
typst compile --format png --ppi 250 --pages 1 template/main.typ thumbnail.png
```

**Size calculation:**
- US Letter = 8.5 in x 11 in
- At 250 PPI: 2125 x 2750 pixels
- Longer edge (2750px) exceeds 1080px requirement by 2.5x
- Typical file size for a document page at 250 PPI: 400 KB - 1.5 MB — well under 3 MiB

**If size exceeds 3 MiB (unlikely but possible):**
```bash
# Optional optimization step — oxipng is lossless
oxipng -o 4 --strip safe thumbnail.png
```

### Pattern 4: Sparse Checkout Workflow

**What:** Clone only `packages/preview/{name}/{version}` subdirectory of the fork.
**When to use:** Inside `make publish` target.

```bash
# Source: git documentation + mslinn.com partial clone guide
# Requires git >= 2.25 (macOS default is 2.39+)

WORK_DIR=$(mktemp -d)
git clone \
  --filter=blob:none \
  --sparse \
  --depth 1 \
  "$FORK_REPO" \
  "$WORK_DIR"

cd "$WORK_DIR"
git sparse-checkout set "packages/preview/$PKG_NAME"
git checkout -b "$BRANCH_NAME"

# Create versioned directory
mkdir -p "$PKG_DIR"

# Copy package files
cp -r $PKG_FILES "$PKG_DIR/"

# Commit and push
git add "$PKG_DIR"
git commit -m "Add $PKG_NAME $PKG_VERSION"
git push "$FORK_REMOTE" "$BRANCH_NAME"

echo "Branch '$BRANCH_NAME' pushed to fork."
echo "Working directory: $WORK_DIR"
echo "Create PR at: https://github.com/typst/packages/compare/$BRANCH_NAME"
```

**Note on `--depth 1` with sparse checkout:** Combining `--filter=blob:none --sparse --depth 1` gives a blobless partial clone with history depth 1 — the fastest approach for this use case. The fork typically has significant history from all other packages.

### Pattern 5: Makefile Target Dependencies

**What:** Target dependency graph ensuring correct execution order.

```makefile
.PHONY: publish thumbnail clean

publish: thumbnail   ## Full publish workflow
	@$(PUBLISH_SCRIPT)

thumbnail:           ## Generate thumbnail.png from template first page
	typst compile --format png --ppi 250 --pages 1 template/main.typ thumbnail.png

clean:               ## Remove local artifacts (thumbnail only; temp clone is self-reported)
	rm -f thumbnail.png
```

**Decision (Claude's discretion):** `make clean` removes only `thumbnail.png` from the project — the temp clone directory is intentionally left for the user to inspect (script prints the path). Users can `rm -rf` the temp dir themselves.

### Anti-Patterns to Avoid

- **Full clone of typst/packages:** The repo has 1,000+ packages and significant history. Never `git clone https://github.com/.../typst-packages.git` without `--filter` and `--sparse`.
- **Writing to project directory:** Never put the packages fork clone inside the project directory — always use `mktemp -d`.
- **Relative imports in template:** The template uses `#import "@preview/misq:0.1.0"` not `#import "../misq.typ"`. This was already established in Phase 4.
- **Implicit file exclusion:** The include list approach (copy only named files) is safer than exclude lists. Don't add an exclude list alongside the include list.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| TOML parsing | Custom parser | `grep + sed` for single field | typst.toml version format is stable and simple |
| PNG compression | Custom compressor | `oxipng` (if needed) | Lossless optimizer handles edge cases |
| Sparse clone | Custom git protocol | `--filter=blob:none --sparse` | Native git, no deps, well-tested |
| Package validation | Validation script | Let Typst Universe CI do it | PR CI catches format errors |

**Key insight:** The publish workflow is essentially a sequence of git and file-copy commands. The complexity is in knowing the right git flags — not in building custom tooling.

---

## Common Pitfalls

### Pitfall 1: Multi-page PNG Filename Template Requirement

**What goes wrong:** Running `typst compile --format png template/main.typ thumbnail.png` on a multi-page document produces an error: filename must contain `{p}` template.
**Why it happens:** Typst requires page-numbered filenames when exporting multiple pages.
**How to avoid:** Always pass `--pages 1` alongside `--format png` when the output filename has no `{p}` template. The `--pages 1` flag restricts export to the first page, making it a single-page export where a plain filename is valid.
**Verified command:**
```bash
typst compile --format png --ppi 250 --pages 1 template/main.typ thumbnail.png
```

### Pitfall 2: Sparse Checkout Cone Mode Behavior

**What goes wrong:** Sparse checkout includes all root-level files by default in cone mode.
**Why it happens:** `git sparse-checkout init --cone` automatically includes root-level files (not subdirectories). This is correct behavior for the use case — only `packages/preview/{name}` is needed.
**How to avoid:** Use `git sparse-checkout set "packages/preview/$PKG_NAME"` — this sets exactly which subdirectory to check out. Root files come along but are lightweight.

### Pitfall 3: Temp Directory Left Behind

**What goes wrong:** Running `make publish` repeatedly creates many temp directories in `/tmp`.
**Why it happens:** The script uses `mktemp -d` and doesn't clean up automatically (by design, so user can inspect).
**How to avoid:** Script prints the temp directory path. Document in Makefile help comments that users can manually remove it. Consider adding `make clean-fork` as an optional target.

### Pitfall 4: README.md Missing

**What goes wrong:** Typst Universe CI rejects the PR because `README.md` is absent from the package directory.
**Why it happens:** No README.md exists in the project root. The publish script copies named files — if README.md is not in the include list and doesn't exist, the fork directory won't have one.
**How to avoid:** **Create README.md as the first task in this phase.** The Makefile include list already references `README.md`; it must exist before `make publish` runs.

### Pitfall 5: Version Already Published

**What goes wrong:** Attempting to push `misq-0.1.0` branch when it already exists on the fork.
**Why it happens:** Re-running `make publish` for the same version.
**How to avoid:** Add a guard check or document that users must bump the version in `typst.toml` before re-running. Simple error message is sufficient — no auto-handling needed.

### Pitfall 6: template/ Directory Copy

**What goes wrong:** `cp -r template/ pkg_dir/` creates `pkg_dir/template/` correctly, but `cp -r template/* pkg_dir/template/` requires the destination to exist first.
**Why it happens:** Shell glob vs directory copy semantics.
**How to avoid:** Use `cp -r template/ "$PKG_DIR/"` (copies the directory itself) or `mkdir -p "$PKG_DIR/template" && cp template/* "$PKG_DIR/template/"`.

---

## Code Examples

Verified patterns from official sources:

### Complete typst compile for thumbnail

```bash
# Source: typst CLI man page (man.archlinux.org/man/extra/typst/typst-compile.1.en)
# --format png: explicit format (also inferred from .png extension)
# --ppi 250: renders at 250 pixels per inch
# --pages 1: export only first page (enables plain filename without {p} template)
typst compile --format png --ppi 250 --pages 1 template/main.typ thumbnail.png
```

### Sparse checkout sequence

```bash
# Source: git documentation + partial clone guide
# Efficient clone: no blobs, sparse, depth 1
WORK_DIR=$(mktemp -d)
git clone --filter=blob:none --sparse --depth 1 "$FORK_REPO" "$WORK_DIR"
cd "$WORK_DIR"
git sparse-checkout set "packages/preview/$PKG_NAME"
git checkout -b "$BRANCH_NAME"
```

### Version extraction from typst.toml

```bash
# Source: verified against typst.toml format ("version = "0.1.0"" pattern)
PKG_VERSION := $(shell grep '^version' typst.toml | sed 's/version = "\(.*\)"/\1/')
```

### Makefile help target (good practice for portability)

```makefile
help:  ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Full clone of typst/packages | `--filter=blob:none --sparse` partial clone | git 2.25+ (2020) | Reduces clone from GB to MB |
| PNG export requires external tools | `typst compile --format png` native | Typst 0.1+ | No ImageMagick or Ghostscript needed |
| Manual file listing for PR | PR via fork branch (not subtree) | Always | PR workflow is the official path |

**Deprecated/outdated:**
- `git config core.sparseCheckout true` + manual `.git/info/sparse-checkout` file: superseded by `git sparse-checkout init` command (use the command, not the config file approach)
- `typst compile --output-format`: old flag name in pre-0.7 typst; current flag is `--format`

---

## Open Questions

1. **README.md content scope**
   - What we know: README.md is required by Typst Universe; must document purpose with examples
   - What's unclear: How detailed does Phase 5 README need to be? Minimal placeholder vs full documentation?
   - Recommendation: Create a minimal but complete README.md (usage, import syntax, parameters) as Wave 1 Task 1 in Phase 5. This is a prerequisite for the publish script.

2. **oxipng availability**
   - What we know: 250 PPI on Letter yields ~2750px, file size typically 400 KB - 1.5 MB
   - What's unclear: Whether the generated thumbnail.png will exceed 3 MiB (unlikely at 250 PPI for a document page)
   - Recommendation: Do not require oxipng. If file exceeds 3 MiB, document it as a manual step.

3. **Git version requirement**
   - What we know: Cone mode sparse checkout requires git >= 2.25; macOS ships 2.39+
   - What's unclear: Whether CI or other environments might have older git
   - Recommendation: Add a git version guard at the top of the publish script with a helpful error message.

---

## Validation Architecture

`workflow.nyquist_validation` is not set in config.json (key absent) — treat as enabled.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None detected — this is a Makefile/bash + Typst project |
| Config file | None (no pytest.ini, jest.config, etc.) |
| Quick run command | `make thumbnail` (smoke test: does typst compile succeed?) |
| Full suite command | `make publish` dry-run inspection (manual) |

### Phase Requirements to Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DEPLOY-04 | thumbnail.png exists with >= 1080px longer edge | smoke | `make thumbnail && python3 -c "from PIL import Image; img=Image.open('thumbnail.png'); assert max(img.size) >= 1080"` | Wave 0 |
| DEPLOY-01 | publish script creates `packages/preview/misq/0.1.0/` with correct files | smoke | `make publish` then manual inspection of printed temp dir | Wave 0 |
| DEPLOY-02 | sparse checkout used (not full clone) | manual | inspect git log in temp dir — only 1 commit | manual-only |
| DEPLOY-03 | portability — config variables at top | manual | read Makefile, change PKG_NAME, verify it works | manual-only |

**Note:** Most verification for this phase is manual inspection, which is appropriate for a publish/deploy script. The main automated check is that `make thumbnail` succeeds and produces a valid PNG.

### Sampling Rate

- **Per task commit:** `make thumbnail` (verifies typst compile works)
- **Per wave merge:** Full `make publish` dry run into temp dir, then inspect
- **Phase gate:** `thumbnail.png` committed, `make publish` produces correct directory structure

### Wave 0 Gaps

- [ ] `Makefile` — does not exist yet, Wave 1 creates it
- [ ] `thumbnail.png` — does not exist yet, created by `make thumbnail`
- [ ] `README.md` — does not exist yet, required by Typst Universe; first task in Wave 1

*(No test framework installation needed — Makefile targets are the "tests")*

---

## Sources

### Primary (HIGH confidence)

- `https://raw.githubusercontent.com/typst/packages/main/docs/manifest.md` — thumbnail requirements (1080px, 3 MiB, PNG/WebP, 250 PPI recommendation), README.md requirement
- `https://man.archlinux.org/man/extra/typst/typst-compile.1.en` — `--format`, `--ppi`, `--pages` flags
- `https://typst.app/docs/reference/png/` — PNG export behavior, default PPI, filename template requirements
- `https://git-scm.com/docs/git-sparse-checkout` — cone mode, `sparse-checkout set` command
- `https://raw.githubusercontent.com/typst/packages/main/docs/README.md` — submission requirements, README.md mandatory

### Secondary (MEDIUM confidence)

- `https://www.mslinn.com/git/600-partial-clone.html` — `--filter=blob:none --sparse` command sequence with verification
- `https://formulae.brew.sh/formula/oxipng` — oxipng installation via brew
- `https://github.com/oxipng/oxipng` — oxipng usage and optimization levels

### Tertiary (LOW confidence)

- Multiple Typst packages forks on GitHub — thumbnail size requirement of 1080px / 3 MiB appears consistently (LOW: secondary source, though consistent)

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — typst CLI, git, make are all well-documented; flags verified against official man page
- Architecture: HIGH — Makefile patterns and git sparse checkout commands verified against official docs
- Pitfalls: HIGH — multi-page PNG filename trap verified against official docs; others are logical consequences of the tools
- Thumbnail requirements: HIGH — verified from typst/packages manifest.md official source

**Research date:** 2026-03-13
**Valid until:** 2026-09-13 (6 months — stable tools; Typst Universe requirements could change with new typst releases)
