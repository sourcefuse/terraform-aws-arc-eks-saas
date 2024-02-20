#!/bin/bash

NAMESPACE="arc-saas"
ENVIRONMENT="dev"
REGION="us-east-1"

# if aws s3 ls "s3://$S3_BUCKET" 2>&1 | grep -q 'NoSuchBucket'; then
#   sed -i '/^[^#]/ s/\(^.*  backend "s3" {}.*$\)/#\ \1/' skeleton/terraform/bootstrap/main.tf
# #  sed -e '/  backend "s3" {}/ s/^#*/#/' -i skeleton/terraform/bootstrap/main.tf
# fi