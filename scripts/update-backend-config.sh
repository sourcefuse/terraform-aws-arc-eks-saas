#!/bin/bash

NAMESPACE="arc-saas"
ENVIRONMENT="dev"
REGION="us-east-1"

TF_STATE_BUCKET=$(aws ssm get-parameter --name "/${NAMESPACE}/${ENVIRONMENT}/terraform-state-bucket" --query 'Parameter.Value' --region "$REGION" --output text 2>/dev/null)
TF_STATE_TABLE=$(aws ssm get-parameter --name "/${NAMESPACE}/${ENVIRONMENT}/terraform-state-dynamodb-table" --query 'Parameter.Value' --region "$REGION" --output text 2>/dev/null)

update_backend () {
    cd terraform/$DIRECTORY
    
}
main() {
    if $UPDATE_BACKEND;
  then
    update_backend
    return $?
  fi
}

main
cleanup