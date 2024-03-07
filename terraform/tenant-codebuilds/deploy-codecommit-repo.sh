#!/bin/bash


REPO_URL="codecommit::${AWS_REGION}://${NAMESPACE}-${ENVIRONMENT}-premium-plan-repository"

git remote add cc $REPO_URL

pip3 install git-remote-codecommit

