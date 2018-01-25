#!/usr/bin/env bash

set -e

source pcf-azure-infrastructure/tasks/provision-infra/terraform-functions.sh


TERRAFORM_SCRIPTS_DIR="pcf-azure-infrastructure/tasks/provision-infra/terraform"
TERRAFORM_STATE_INPUT_DIR="terraform-infra-state"
TERRAFORM_STATE_OUTPUT_DIR="terraform-infra-state-output"

run_terraform ${TERRAFORM_SCRIPTS_DIR} ${TERRAFORM_STATE_INPUT_DIR} ${TERRAFORM_STATE_OUTPUT_DIR}

