#!/bin/bash

# Set  environment variable
export AWS_REGION=
export NAMESPACE=
export ENVIRONMENT=


# Retrieve GitHub username from SSM Parameter Store
GITHUB_USERNAME=$(aws ssm get-parameter --name "/github_user" --with-decryption --region "${AWS_REGION}" --query "Parameter.Value" --output text)
if [ -z "$GITHUB_USERNAME" ]; then
  echo "Failed to retrieve GitHub username from SSM Parameter Store"
  exit 1
fi

# Retrieve GitHub token from SSM Parameter Store
GITHUB_TOKEN=$(aws ssm get-parameter --name "/github_token" --with-decryption --region "${AWS_REGION}" --query "Parameter.Value" --output text)
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Failed to retrieve GitHub token from SSM Parameter Store"
  exit 1
fi

# Retrieve GitHub Repo from SSM Parameter Store
GITHUB_REPO=$(aws ssm get-parameter --name "/github_saas_repo" --with-decryption --region "${AWS_REGION}" --query "Parameter.Value" --output text)
if [ -z "$GITHUB_REPO" ]; then
  echo "Failed to retrieve GitHub repo from SSM Parameter Store"
  exit 1
fi

# Construct the GitHub repository URL
GITHUB_REPO_URL="https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git"

# Check if the directory already exists and remove it if necessary
if [ -d "${NAMESPACE}-saas-management-repository" ]; then
    echo "Directory '${NAMESPACE}-saas-management-repository' already exists. Removing it."
    rm -rf "${NAMESPACE}-saas-management-repository" || { echo "Failed to remove existing directory"; exit 1; }
fi

# Clone the GitHub repository
git clone "${GITHUB_REPO_URL}" || { echo "Failed to clone GitHub repository"; exit 1; }

# Change to the cloned repository directory
cd "${NAMESPACE}-saas-management-repository" || { echo "Failed to change directory to cloned repository"; exit 1; }

# Copy control-plane values.yaml to control-plane directory
if [ -d "../output" ]; then
    cp -r ../output/* control-plane/ || { echo "Failed to copy files"; exit 1; }
else
    echo "'output' folder does not exist. Skipping file copy."
fi

# Configure Git with user details
git config --global --unset credential.helper
git config --global credential.helper 'cache --timeout=900'
git config --global user.email 'devops@sourcefuse.com' || { echo "Failed to configure user email"; exit 1; }
git config --global user.name 'sfdevops' || { echo "Failed to configure user name"; exit 1; }

# Add and commit changes
if [ -n "$(git status --porcelain)" ]; then
    git add . || { echo "Failed to add files"; exit 1; }
    git commit -m 'control plane values.yaml updated' || { echo "Failed to commit changes"; exit 1; }
    git push ${GITHUB_REPO_URL} main || { echo "Failed to push changes"; exit 1; }
    echo "Changes committed and pushed successfully"
else
    echo "Nothing to commit, working tree clean. Exiting..."
fi

echo "Script executed successfully"