SHELL := /bin/bash
.ONESHELL:

# ============================================================
# Configuration — change these lines for another project
# ============================================================
PKG_NAME    := magnificent-misq
GITHUB_USER := rschuetzler
FORK_REPO   := https://github.com/$(GITHUB_USER)/typst-packages.git

# Derived — do not edit
PKG_VERSION := $(shell grep '^version' typst.toml | sed 's/version = "\(.*\)"/\1/')
BRANCH_NAME := $(PKG_NAME)-$(PKG_VERSION)
PKG_DIR     := packages/preview/$(PKG_NAME)/$(PKG_VERSION)

# Files to include in the package (explicit list)
PKG_FILES   := misq.typ apa.csl typst.toml thumbnail.png LICENSE README.md
PKG_DIRS    := template

.PHONY: help thumbnail publish clean

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

thumbnail: ## Generate thumbnail.png from template first page
	typst compile --format png --ppi 250 --pages 1 --root . template/main.typ thumbnail.png
	@echo "Generated thumbnail.png"
	@ls -lh thumbnail.png

publish: thumbnail ## Publish package to typst-packages fork (sparse clone, copy files, commit, push)
	@set -euo pipefail; \
	command -v typst >/dev/null 2>&1 || { echo "Error: typst CLI not found. Install from https://github.com/typst/typst"; exit 1; }; \
	command -v git >/dev/null 2>&1 || { echo "Error: git not found."; exit 1; }; \
	echo "Publishing: $(PKG_NAME) $(PKG_VERSION)"; \
	echo "Branch:     $(BRANCH_NAME)"; \
	echo "Directory:  $(PKG_DIR)"; \
	WORK_DIR=$$(mktemp -d); \
	echo "Working in: $$WORK_DIR"; \
	git clone --filter=blob:none --sparse --depth 1 "$(FORK_REPO)" "$$WORK_DIR"; \
	cd "$$WORK_DIR"; \
	git sparse-checkout set "packages/preview/$(PKG_NAME)"; \
	git checkout -b "$(BRANCH_NAME)"; \
	mkdir -p "$(PKG_DIR)"; \
	for f in $(PKG_FILES); do \
		cp "$(CURDIR)/$$f" "$(PKG_DIR)/$$f"; \
	done; \
	mkdir -p "$(PKG_DIR)/template"; \
	cp "$(CURDIR)/template/main.typ" "$(CURDIR)/template/references.bib" "$(PKG_DIR)/template/"; \
	git add "$(PKG_DIR)"; \
	git commit -m "Add $(PKG_NAME) $(PKG_VERSION)"; \
	git push origin "$(BRANCH_NAME)"; \
	echo ""; \
	echo "Branch pushed to fork: $(BRANCH_NAME)"; \
	echo "Working directory: $$WORK_DIR"; \
	echo ""; \
	echo "Create PR at: https://github.com/typst/packages/compare/main...$(GITHUB_USER):typst-packages:$(BRANCH_NAME)"

clean: ## Remove generated thumbnail.png
	rm -f thumbnail.png
	@echo "Removed thumbnail.png"
