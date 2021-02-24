
## User Defined Variables
TEST_HARNESS ?= $(PWD)/cst.yml
GIT_COMMIT_REV ?= $(shell git log -n 1 --pretty=format:'%h')
GIT_SCM_URL ?= $(shell git config --get remote.origin.url)
SCM_URI ?= $(subst git@github.com:,https://github.com/,$(GIT_SCM_URL))
BUILD_DATE ?= $(shell date --utc '+%Y-%m-%dT%H:%M:%S' 2>/dev/null || gdate --utc '+%Y-%m-%dT%H:%M:%S')
CONTAINER_BIN ?= img
PLATFORM ?= linux/amd64

## Image Setup
# Search for image name in the file .image_suffix or default to the name of the parent directory
image_suffix = $(shell cat $(PWD)/.image_suffix 2>/dev/null || basename $(PWD))
image_name = jenkinsciinfra/inbound-agent-$(image_suffix)
dockerfile = Dockerfile
image_archive = $(PWD)/image.tar

help: ## Show this Makefile's help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: clean lint build test ## Execute the complete process except the "deploy" step

lint: ## Lint the $(dockerfile) content
	@echo "== Linting $(PWD)/$(dockerfile)..."
	@echo "Writing Lint results to $(PWD)/hadolint.json"
	@hadolint --format=json $(PWD)/$(dockerfile) > $(PWD)/hadolint.json
	@echo "== Lint ✅ Succeeded"

build: ## Build the Docker Image $(image_name) from $(dockerfile) and export it to $(image_archive)
	@echo "== Building image '$(image_name)' from $(PWD)/$(dockerfile)..."
	@$(CONTAINER_BIN) build \
		-t $(image_name) \
		--build-arg "GIT_COMMIT_REV=$(GIT_COMMIT_REV)" \
		--build-arg "GIT_SCM_URL=$(GIT_SCM_URL)" \
		--build-arg "BUILD_DATE=$(BUILD_DATE)" \
		--label "org.opencontainers.image.source=$(GIT_SCM_URL)" \
		--label "org.label-schema.vcs-url=$(GIT_SCM_URL)" \
		--label "org.opencontainers.image.url=$(SCM_URI)" \
		--label "org.label-schema.url=$(SCM_URI)" \
		--label "org.opencontainers.image.revision=$(GIT_COMMIT_REV)" \
		--label "org.label-schema.vcs-ref=$(GIT_COMMIT_REV)" \
		--label "org.opencontainers.image.created=$(BUILD_DATE)" \
		--label "org.label-schema.build-date=$(BUILD_DATE)" \
		--platform $(PLATFORM) \
		-f $(PWD)/$(dockerfile) \
		$(PWD)
	@$(CONTAINER_BIN) save --output=$(image_archive) $(image_name)
	@echo "== Build ✅ Succeeded, image $(image_name) exported to $(image_archive)."

clean: ## Delete any file generated during the build steps
	@echo "== Cleaning working directory from generated artefacts..."
	@rm -f $(PWD)/*.tar $(PWD)/hadolint.json
	@echo "== Cleanup ✅ Succeeded"

test: ## Execute the test harness on the Docker Image archive at $(image_archive)
	@echo "== Testing $(image_name) from $(image_archive)..."
	@echo "Writing test report to $(PWD)/cst-result.xml..."
	@container-structure-test test --driver=tar --image=$(image_archive) --config=$(TEST_HARNESS)
	@echo "== Test ✅ Succeeded"

## This steps expects that you are logged to the Docker registry to push image into
deploy: ## Deploy (e.g. push to remote container registry) the image $(image_name)
	@echo "== Deploying $(image_name)..."
	$(CONTAINER_BIN) push $(image_name)
	@echo "== Deploy ✅ Succeeded"

.PHONY: all clean lint build test deploy
