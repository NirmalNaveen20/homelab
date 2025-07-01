# Set the subscription 
export ARM_SUBSCRIPTION_ID=""

# Set the application / environment 
export TF_VAR_application_name="linuxvm"
export TF_VAR_environment_name="dev"

# Set the backend 
export BACKEND_RESOURCE_GROUP="chocolate-dev-rg"
export BACKEND_STORAGE_ACCOUNT="backendlabs"
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