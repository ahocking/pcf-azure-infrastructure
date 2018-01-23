#!/usr/bin/env bash

set -e

source tasks/provision-infra/terraform-functions.sh
source scripts/parse_yaml.sh

# Pull variables from pipline yaml files
# TODO check for file exists
eval $(parse_yaml params.yml)
# TODO check for file exists
eval $(parse_yaml creds.yml)

TERRAFORM_SCRIPTS_DIR="tasks/provision-infra/terraform"
TERRAFORM_STATE_INPUT_DIR="."
TERRAFORM_STATE_OUTPUT_DIR="."

run_terraform ${TERRAFORM_SCRIPTS_DIR} ${TERRAFORM_STATE_INPUT_DIR} ${TERRAFORM_STATE_OUTPUT_DIR}
