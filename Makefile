.PHONY: all install-tools validate fmt docs test test-parallel

all: install-tools validate fmt docs

install-tools:
	go install github.com/terraform-docs/terraform-docs@latest

TEST_ARGS := $(if $(skip-destroy),-skip-destroy=$(skip-destroy)) \
             $(if $(exception),-exception=$(exception)) \
             $(if $(example),-example=$(example))

EXAMPLE ?= default
EXAMPLE_PATH := examples/$(EXAMPLE)/main.tf
REPO_NAME := $(notdir $(CURDIR))
MODULE_SLUG := $(shell echo $(REPO_NAME) | awk -F'-' '{print $$NF}')

test:
	@echo "Temporarily setting source to local for module '$(MODULE_SLUG)' in $(EXAMPLE_PATH) and removing version if present"
	@cp $(EXAMPLE_PATH) $(EXAMPLE_PATH).bak
	@awk -v slug="$(MODULE_SLUG)" '$$1 == "module" && $$2 ~ ("\""slug"\"") {in_sql=1} in_sql && $$1 == "source" {print "  source = \"../..\""; next} in_sql && $$1 == "version" {next} /^}/ {in_sql=0} {print}' $(EXAMPLE_PATH).bak > $(EXAMPLE_PATH)
	cd tests && go test -v -timeout 60m -parallel 20 -run '^TestApplyNoError$$' -args $(TEST_ARGS) .
	@echo "Restoring original source in $(EXAMPLE_PATH)"
	@mv $(EXAMPLE_PATH).bak $(EXAMPLE_PATH)

test-parallel:
	@for ex in examples/*; do \
		if [ -f "$$ex/main.tf" ]; then \
			echo "Temporarily setting source to local for module '$(MODULE_SLUG)' in $$ex/main.tf and removing version if present"; \
			cp $$ex/main.tf $$ex/main.tf.bak; \
			awk -v slug="$(MODULE_SLUG)" '$$1 == "module" && $$2 ~ ("\""slug"\"") {in_sql=1} in_sql && $$1 == "source" {print "  source = \"../..\""; next} in_sql && $$1 == "version" {next} /^}/ {in_sql=0} {print}' $$ex/main.tf.bak > $$ex/main.tf; \
		fi; \
	done
	cd tests && go test -v -timeout 60m -run '^TestApplyAllParallel$$' -args $(TEST_ARGS) .
	@for ex in examples/*; do \
		if [ -f "$$ex/main.tf.bak" ]; then \
			echo "Restoring original source in $$ex/main.tf"; \
			mv $$ex/main.tf.bak $$ex/main.tf; \
		fi; \
	done

docs:
	@echo "Generating documentation for root and modules..."
	terraform-docs markdown document . --output-file README.md --output-mode inject --hide modules
	for dir in modules/*; do \
		if [ -d "$$dir" ]; then \
			echo "Processing $$dir..."; \
			(cd "$$dir" && terraform-docs markdown document . --output-file README.md --output-mode inject --hide modules) || echo "Skipped: $$dir"; \
		fi \
	done

fmt:
	terraform fmt -recursive

validate:
	terraform init -backend=false
	terraform validate
	@echo "Cleaning up initialization files..."
	rm -rf .terraform terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
