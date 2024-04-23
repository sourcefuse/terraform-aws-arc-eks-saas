#!/bin/bash

# Define new variable values
NEW_AWS_REGION="us-east-1"
NEW_NAMESPACE="arc-saas"
NEW_ENVIRONMENT="dev"
DOMAIN="arc-saas.net"

# Find and replace the variables in all .sh files
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i "s/AWS_REGION=.*/AWS_REGION=$NEW_AWS_REGION/g" {} +
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i "s/NAMESPACE=.*/NAMESPACE=$NEW_NAMESPACE/g" {} +
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i "s/ENVIRONMENT=.*/ENVIRONMENT=$NEW_ENVIRONMENT/g" {} +

find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i "s/REGION=.*/REGION=$NEW_AWS_REGION/g" {} +
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i "s/NAMESPACE=.*/NAMESPACE=$NEW_NAMESPACE/g" {} +
find . -type f -name "*.sh" ! -name "$(basename "$0")" -exec sed -i "s/ENVIRONMENT=.*/ENVIRONMENT=$NEW_ENVIRONMENT/g" {} +


find . -type f -name "*.tfvars" -exec sed -i "s/^\s*region\s*=.*/region = \"$NEW_AWS_REGION\"/g" {} +
find . -type f -name "*.tfvars" -exec sed -i "s/^\s*namespace\s*=.*/namespace = \"$NEW_NAMESPACE\"/g" {} +
find . -type f -name "*.tfvars" -exec sed -i "s/^\s*environment\s*=.*/environment = \"$NEW_ENVIRONMENT\"/g" {} +
find . -type f -name "*.tfvars" -exec sed -i "s/^\s*domain_name\s*=.*/domain_name = \"$DOMAIN\"/g" {} +

echo "Variables replaced successfully."
