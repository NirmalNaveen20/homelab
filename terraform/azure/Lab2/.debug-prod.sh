# Set the subscription 
export ARM_SUBSCRIPTION_ID=""

# Set the application / environment 
export TF_VAR_application_name="observability"
export TF_VAR_environment_name="prod"

# Set the backend 
export BACKEND_RESOURCE_GROUP="chocolate-prod-rg"
export BACKEND_STORAGE_ACCOUNT="wahrub6ws2st"
export BACKEND_STORAGE_CONTAINER="tfstate" 
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name

# Run terraform 
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}"

terraform "$@"

rm -rf .terraform