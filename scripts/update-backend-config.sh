#!/bin/bash
set -e


UPDATE_BACKEND=false

while getopts "u:d:" option; do
  case $option in
    u) #update backend
    export ENV=$OPTARG
    UPDATE_BACKEND=true
    ;;
    d) #set directory
    DIRECTORY=$OPTARG
    ;;
     \?)
    echo "ERROR: Invalid option $option"
    echo "valid options are : [-d|u]"
    break;
    ;;
  esac
done


NAMESPACE=
ENVIRONMENT=
REGION=us-east-1

TF_STATE_BUCKET=$(aws ssm get-parameter --name "/${NAMESPACE}/${ENVIRONMENT}/terraform-state-bucket" --query 'Parameter.Value' --region "$REGION" --output text 2>/dev/null)
TF_STATE_TABLE=$(aws ssm get-parameter --name "/${NAMESPACE}/${ENVIRONMENT}/terraform-state-dynamodb-table" --query 'Parameter.Value' --region "$REGION" --output text 2>/dev/null)

update_backend () {
    cd terraform/$DIRECTORY
    sed -i "s/^bucket *=.*/bucket = \"${TF_STATE_BUCKET}\"/" config.hcl
    sed -i "s/^dynamodb_table *=.*/dynamodb_table = \"${TF_STATE_TABLE}\"/" config.hcl
    sed -i "s/^region *=.*/region = \"${REGION}\"/" config.hcl
    cat config.hcl

}
main() {
    if $UPDATE_BACKEND;
  then
    update_backend
    return $?
  fi
}

main