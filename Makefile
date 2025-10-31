# ===============================================
# Terraform Makefile (multi-env)
# Author: daeun-ops
# Repo: infra-terraform
# ===============================================

# Default environment (can be overridden: `make plan ENV=stg`)
ENV ?= dev
TF_DIR := envs/$(ENV)

# ANSI colors for better readability
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
RESET := \033[0m

.PHONY: help init validate fmt plan apply destroy outputs lint

help:
	@echo ""
	@echo "$(BLUE)Terraform Makefile Commands$(RESET)"
	@echo ""
	@echo "$(YELLOW)Usage:$(RESET) make [target] ENV=dev|stg|prod"
	@echo ""
	@echo "$(GREEN)Targets:$(RESET)"
	@echo "  init       Initialize Terraform backend for selected ENV"
	@echo "  validate   Validate configuration syntax"
	@echo "  fmt        Format all Terraform files recursively"
	@echo "  plan       Show execution plan"
	@echo "  apply      Apply changes automatically"
	@echo "  destroy    Tear down infrastructure"
	@echo "  outputs    Display all outputs in JSON"
	@echo "  lint       Run tflint for static analysis"
	@echo ""

init:
	cd $(TF_DIR) && terraform init -reconfigure -backend-config=backend.hcl

validate:
	cd $(TF_DIR) && terraform validate

fmt:
	terraform fmt -recursive
	@echo "$(GREEN)✔ Terraform files formatted.$(RESET)"

plan:
	cd $(TF_DIR) && terraform plan -var-file=terraform.tfvars

apply:
	cd $(TF_DIR) && terraform apply -auto-approve -var-file=terraform.tfvars

destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve -var-file=terraform.tfvars

outputs:
	cd $(TF_DIR) && terraform output -json | jq

lint:
	cd $(TF_DIR) && tflint --init && tflint
