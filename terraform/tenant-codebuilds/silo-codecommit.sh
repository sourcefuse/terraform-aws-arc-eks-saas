#!/bin/bash

# Set  environment variable
export AWS_REGION=us-east-1
export NAMESPACE=arc-saas
export ENVIRONMENT=dev

# Change directory to ../../samples/
cd ../../samples/ || { echo "Failed to change directory"; exit 1; }

# Install git-remote-codecommit
pip3 install git-remote-codecommit || { echo "Failed to install git-remote-codecommit"; exit 1; }

# Clone codecommit::us-east-1://demo-test
git clone codecommit::${AWS_REGION}://${NAMESPACE}-${ENVIRONMENT}-premium-plan-repository || { echo "Failed to clone repository"; exit 1; }

# Change directory to demo-test
cd ${NAMESPACE}-${ENVIRONMENT}-premium-plan-repository || { echo "Failed to change directory"; exit 1; }

# List files in the directory
ls -la

# Copy contents from ../demo-test/ to current directory
cp -r ../silo-tenant/* . || { echo "Failed to copy files"; exit 1; }

# List files in the directory after copying
ls -la

# Set origin URL
git remote set-url origin codecommit::us-east-1://${NAMESPACE}-${ENVIRONMENT}-premium-plan-repository || { echo "Failed to set remote URL"; exit 1; }

# Check if main branch already exists
if git show-ref --verify --quiet refs/heads/main; then
    echo "Main branch already exists. Skipping branch creation."
else
    # Create and switch to main branch
    git checkout -b main || { echo "Failed to create and switch to main branch"; exit 1; }
fi

# Configure user email
git config --global user.email 'devops@sourcefuse.com' || { echo "Failed to configure user email"; exit 1; }

# Configure user name
git config --global user.name 'sfdevops' || { echo "Failed to configure user name"; exit 1; }

# Add all files
git add . || { echo "Failed to add files"; exit 1; }

# Commit changes
git commit -m 'Committing sample silo-tenant' || { echo "Failed to commit changes"; exit 1; }

# Push changes to origin main
git push origin main || { echo "Failed to push changes"; exit 1; }

echo "Script executed successfully"
