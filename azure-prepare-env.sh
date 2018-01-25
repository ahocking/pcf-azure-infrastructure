#!/usr/bin/env bash

set -eEu

source scripts/parse_yaml.sh

# Pull variables from pipline yaml files
# TODO check for file exists
eval $(parse_yaml params.yml "")
# TODO check for file exists
eval $(parse_yaml creds.yml "")

IDENTIFIER_URI="http://NETWORKAzureCPI-${azure_terraform_prefix}"
DISPLAY_NAME="${azure_terraform_prefix}-Service Principal for NETWORK"

# ===============
# Create app and service principal for the Network resource group

# check for existing app by identifier-uri
AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID=$(az ad app list \
  --identifier-uri "${IDENTIFIER_URI}" \
  | jq -r " .[] | .appId" )

if [[ -z "$AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID" ]]; then
    echo "Creating client ${DISPLAY_NAME}"
    # create network application client
    AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID=$(az ad app create \
      --display-name "${DISPLAY_NAME}" \
      --password "${azure_network_service_principal_client_secret}" \
      --homepage "${IDENTIFIER_URI}" \
      --identifier-uris "${IDENTIFIER_URI}" \
      | jq -r ".appId" )
else
    echo "...Skipping client ${DISPLAY_NAME}.  Already exists."
fi

SERVICE_PRINCIPAL_NAME=$(az ad sp list --display-name "${DISPLAY_NAME}" | jq -r ".[] | .appId")

if [[ -z "$SERVICE_PRINCIPAL_NAME" ]]; then
    echo "Creating service principal ${DISPLAY_NAME}"
    # create network service principal
    SERVICE_PRINCIPAL_NAME=$(az ad sp create \
      --id ${AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID} \
      | jq -r ".appId" )
else
    echo "...Skipping service principal ${DISPLAY_NAME}.  Already exists."
fi

ROLE_ID=$(az role assignment list \
  --assignee ${SERVICE_PRINCIPAL_NAME} \
  --role "Contributor" \
  --scope /subscriptions/${azure_subscription_id} \
  | jq -r ".[] | .id")

if [[ -z "$ROLE_ID" ]]; then

    echo "Applying Contributor access to ${DISPLAY_NAME}"
    ROLE_ID=$(az role assignment create \
      --assignee "${SERVICE_PRINCIPAL_NAME}" \
      --role "Contributor" \
      --scope /subscriptions/${azure_subscription_id} \
       | jq -r ".id")
else
    echo "...Skipping Contributor roll assignment ${DISPLAY_NAME}.  Already assigned."
fi

# ===============
# Create app and service principal for the BOSH/PCF resource group

BOSH_IDENTIFIER_URI="http://BOSHAzureCPI-${azure_terraform_prefix}"
BOSH_DISPLAY_NAME="${azure_terraform_prefix}-Service Principal for BOSH"

# check for existing app by identifier-uri
AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID=$(az ad app list \
  --identifier-uri "${BOSH_IDENTIFIER_URI}" \
  | jq -r " .[] | .appId" )

if [[ -z "$AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID" ]]; then
    echo "Creating client ${BOSH_DISPLAY_NAME}"
    # create BOSH application client
    AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID=$(az ad app create \
      --display-name "${BOSH_DISPLAY_NAME}" \
      --password "${azure_pcf_service_principal_client_secret}" \
      --homepage "${BOSH_IDENTIFIER_URI}" \
      --identifier-uris "${BOSH_IDENTIFIER_URI}" \
      | jq -r ".appId" )
else
    echo "...Skipping client ${BOSH_DISPLAY_NAME}.  Already exists."
fi

SERVICE_PRINCIPAL_NAME=$(az ad sp list --display-name "${BOSH_DISPLAY_NAME}" | jq -r ".[] | .appId")

if [[ -z "$SERVICE_PRINCIPAL_NAME" ]]; then
    echo "Creating service principal ${BOSH_DISPLAY_NAME}"
    # create BOSH service principal
    SERVICE_PRINCIPAL_NAME=$(az ad sp create \
      --id ${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID} \
      | jq -r ".appId" )
else
    echo "...Skipping service principal ${BOSH_DISPLAY_NAME}.  Already exists."
fi

# create custom roles
ROLE_NETWORK_READONLY_NAME="PCF Network Read Only (custom)"
ROLE_NETWORK_READONLY_JSON=$(jq -n --arg azure_subscription_id "/subscriptions/${azure_subscription_id}" \
    '
    {
      "Name": "PCF Network Read Only (custom)",
      "IsCustom": true,
      "Description": "PCF Read Network Resource Group (custom)",
      "Actions": [
        "Microsoft.Network/networkSecurityGroups/read",
        "Microsoft.Network/networkSecurityGroups/join/action",
        "Microsoft.Network/publicIPAddresses/read",
        "Microsoft.Network/publicIPAddresses/join/action",
        "Microsoft.Network/loadBalancers/read",
        "Microsoft.Network/virtualNetworks/subnets/read",
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/read"
      ],
      "NotActions": [],
      "AssignableScopes": [$azure_subscription_id]
    }
    ')


ROLE_NETWORK_READ_ONLY=$(az role definition list \
  --custom-role-only true \
  --name "${ROLE_NETWORK_READONLY_NAME}" \
  --scope "/subscriptions/${azure_subscription_id}" | jq -r ".[0]")

if [[ -z "${ROLE_NETWORK_READ_ONLY/null/}" ]]; then
    echo "Creating custom role ${ROLE_NETWORK_READONLY_NAME}"
    ROLE_NETWORK_READ_ONLY=$(az role definition create \
    --role-definition "${ROLE_NETWORK_READONLY_JSON}" )
else
    echo "...Skipping custom role ${ROLE_NETWORK_READONLY_NAME}.  Already exists."
fi

ROLE_ASSIGNMENT_NETWORK=$(az role assignment list \
  --role "${ROLE_NETWORK_READONLY_NAME}" \
  --assignee ${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID} \
  --scope "/subscriptions/${azure_subscription_id}" | jq -r ".[0]")

if [[ -z "${ROLE_ASSIGNMENT_NETWORK/null/}" ]]; then
    echo "Assigning custom role ${ROLE_NETWORK_READONLY_NAME} to BOSH/PCF service principal"
    ROLE_ASSIGNMENT_NETWORK=$(az role assignment create \
      --role "${ROLE_NETWORK_READONLY_NAME}" \
      --assignee ${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID} \
      --scope "/subscriptions/${azure_subscription_id}")
else
    echo "...Skipping assignment of custom role ${ROLE_NETWORK_READONLY_NAME}.  Already assigned."
fi

ROLE_PCF_DEPLOY_NAME="PCF Deploy Min Perms (custom)"
ROLE_PCF_DEPLOY_JSON=$(jq -n --arg azure_subscription_id "/subscriptions/${azure_subscription_id}" \
    '
    {
      "Name": "PCF Deploy Min Perms (custom)",
      "IsCustom": true,
      "Description": "PCF Terraform Perms (custom)",
      "Actions": [
        "Microsoft.Compute/register/action"
      ],
      "NotActions": [],
      "AssignableScopes": [$azure_subscription_id]
    }
    ')

ROLE_PCF_DEPLOY_ONLY=$(az role definition list \
  --custom-role-only true \
  --name "${ROLE_PCF_DEPLOY_NAME}" \
  --scope "/subscriptions/${azure_subscription_id}" | jq -r ".[0]")


if [[ -z "${ROLE_PCF_DEPLOY_ONLY/null/}" ]]; then
    echo "Creating custom role ${ROLE_PCF_DEPLOY_NAME}"
    ROLE_PCF_DEPLOY_ONLY=$(az role definition create \
    --role-definition "${ROLE_PCF_DEPLOY_JSON}" )
else
    echo "...Skipping custom role ${ROLE_PCF_DEPLOY_NAME}.  Already exists."
fi

ROLE_ASSIGNMENT_PCF_DEPLOY=$(az role assignment list \
  --role "${ROLE_PCF_DEPLOY_NAME}" \
  --assignee ${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID} \
  --scope "/subscriptions/${azure_subscription_id}" | jq -r ".[0]")

if [[ -z "${ROLE_ASSIGNMENT_PCF_DEPLOY/null/}" ]]; then
    echo "Assigning custom role ${ROLE_PCF_DEPLOY_NAME} to BOSH/PCF service principal"
    ROLE_ASSIGNMENT_PCF_DEPLOY=$(az role assignment create \
      --role "${ROLE_PCF_DEPLOY_NAME}" \
      --assignee ${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID} \
      --scope "/subscriptions/${azure_subscription_id}")
else
    echo "...Skipping assignment of custom role ${ROLE_PCF_DEPLOY_NAME}.  Already assigned."
fi

# ===============
# Create the initial network resource group so the terraform storage container can be created

# create initial resource group to put terraform
RES_GROUP=$(az group show --name "${azure_multi_resgroup_network}")

if [[ -z "$RES_GROUP" ]]; then
    RES_GROUP=$(az group create --name "${azure_multi_resgroup_network}" --location "${azure_region}")
else
    echo "...Skipping resource group ${azure_multi_resgroup_network}.  Already exists."
fi

# create storage account for infra terraform pipeline
STORAGE_ACCOUNT=$(az storage account show --name "${azure_infra_terraform_storage_account}" --resource-group "${azure_multi_resgroup_network}")

if [[ -z "$STORAGE_ACCOUNT" ]]; then
    STORAGE_ACCOUNT=$(az storage account create \
      --name "${azure_infra_terraform_storage_account}" \
      --resource-group "${azure_multi_resgroup_network}" \
      --sku "Standard_LRS")
else
  echo "...Skipping storage account ${azure_infra_terraform_storage_account}.  Already exists."
fi

STORAGE_CONTAINER=$(az storage container show --name "${azure_infra_terraform_container_name}" --account-name "${azure_infra_terraform_storage_account}")
if [[ -z "$STORAGE_CONTAINER" ]]; then
    STORAGE_CONTAINER=$(az storage container create \
      --name "${azure_infra_terraform_container_name}" \
      --account-name="${azure_infra_terraform_storage_account}")
else
    echo "...Skipping storage container ${azure_infra_terraform_container_name}.  Already exists."
fi

echo
echo "Populate creds.yml with these values:"
echo
echo "azure_network_service_principal_client_id: ${AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID}"
echo "azure_pcf_service_principal_client_id: ${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID}"

