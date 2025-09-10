#!/bin/bash

# Define new variable values
NEW_AWS_REGION="us-east-1"
NEW_NAMESPACE="saas-demo"
NEW_ENVIRONMENT="dev"
DOMAIN="arc-saas.net"

# Update .sh files (skip this script itself)
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i '' "s/AWS_REGION=.*/AWS_REGION=$NEW_AWS_REGION/g" {} +
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i '' "s/NAMESPACE=.*/NAMESPACE=$NEW_NAMESPACE/g" {} +
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i '' "s/ENVIRONMENT=.*/ENVIRONMENT=$NEW_ENVIRONMENT/g" {} +
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i '' "s/REGION=.*/REGION=$NEW_AWS_REGION/g" {} +

# Update .tfvars files
find . -type f -name "*.tfvars" -exec sed -i '' "s/^[[:space:]]*region[[:space:]]*=.*/region = \"$NEW_AWS_REGION\"/g" {} +
find . -type f -name "*.tfvars" -exec sed -i '' "s/^[[:space:]]*namespace[[:space:]]*=.*/namespace = \"$NEW_NAMESPACE\"/g" {} +
find . -type f -name "*.tfvars" -exec sed -i '' "s/^[[:space:]]*environment[[:space:]]*=.*/environment = \"$NEW_ENVIRONMENT\"/g" {} +
find . -type f -name "*.tfvars" -exec sed -i '' "s/^[[:space:]]*domain_name[[:space:]]*=.*/domain_name = \"$DOMAIN\"/g" {} +

echo "Variables replaced successfully."
