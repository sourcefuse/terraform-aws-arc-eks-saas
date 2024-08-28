
##################################################################################
## Copying files to Github repository
##################################################################################
#!/bin/bash

# Set environment variables
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

# Change directory
cd ../../files/ || { echo "Failed to change directory"; exit 1; }

# Check if the directory already exists and remove it if necessary
if [ -d "${NAMESPACE}-saas-management-repository" ]; then
    echo "Directory '${NAMESPACE}-saas-management-repository' already exists. Removing it."
    rm -rf "${NAMESPACE}-saas-management-repository" || { echo "Failed to remove existing directory"; exit 1; }
fi

# Clone the GitHub repository
git clone "${GITHUB_REPO_URL}" || { echo "Failed to clone GitHub repository"; exit 1; }

# Change to the cloned repository directory
cd "${NAMESPACE}-saas-management-repository" || { echo "Failed to change directory to cloned repository"; exit 1; }

# Function to create directory if it doesn't exist
create_directory() {
    local dir_name=$1
    if [ ! -d "$dir_name" ]; then
        mkdir "$dir_name" || { echo "Failed to create '$dir_name' folder"; exit 1; }
    else
        echo "The '$dir_name' folder already exists."
    fi
}

# Create directories and subdirectories
create_directory "tenant-templates"
create_directory "tenant-templates/silo"
create_directory "tenant-templates/pooled"
create_directory "tenant-templates/bridge"

create_directory "onboarded-tenants"
create_directory "control-plane"
create_directory "onboarded-tenants/pooled"
create_directory "onboarded-tenants/pooled/application"
create_directory "onboarded-tenants/pooled/infra"
create_directory "onboarded-tenants/bridge"
create_directory "onboarded-tenants/bridge/application"
create_directory "onboarded-tenants/bridge/infra"
create_directory "onboarded-tenants/silo"
create_directory "onboarded-tenants/silo/application"
create_directory "onboarded-tenants/silo/infra"


# Copy contents for pooled tenant to the cloned repository
cp -r ../tenant-samples/pooled/* tenant-templates/pooled/ || { echo "Failed to copy files"; exit 1; }

# Copy contents for bridge tenant to the cloned repository
cp -r ../tenant-samples/bridge/* tenant-templates/bridge/ || { echo "Failed to copy files"; exit 1; }

# Copy contents for silo tenant to the cloned repository
cp -r ../tenant-samples/silo/* tenant-templates/silo/ || { echo "Failed to copy files"; exit 1; }

# Copy contents for tenant management and control plane management to the cloned repository
cp -r ../control-plane/control-plane-helm-chart/* control-plane/ || { echo "Failed to copy files"; exit 1; }
rm -rf control-plane/values.yaml.template

cp -r ../tenant-samples/pooled/tenant-helm-chart/* onboarded-tenants/pooled/application/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/pooled/tenant-helm-chart onboarded-tenants/pooled/infra/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/pooled/modules onboarded-tenants/pooled/infra/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/pooled/terraform onboarded-tenants/pooled/infra/ || { echo "Failed to copy files"; exit 1; }
rm -rf onboarded-tenants/pooled/application/values.yaml.template

cp -r ../tenant-samples/bridge/tenant-helm-chart/* onboarded-tenants/bridge/application/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/bridge/tenant-helm-chart onboarded-tenants/bridge/infra/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/bridge/modules onboarded-tenants/bridge/infra/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/bridge/terraform onboarded-tenants/bridge/infra/ || { echo "Failed to copy files"; exit 1; }
rm -rf onboarded-tenants/bridge/application/values.yaml.template

cp -r ../tenant-samples/silo/tenant-helm-chart/* onboarded-tenants/silo/application/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/silo/tenant-helm-chart onboarded-tenants/silo/infra/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/silo/modules onboarded-tenants/silo/infra/ || { echo "Failed to copy files"; exit 1; }
cp -r ../tenant-samples/silo/terraform onboarded-tenants/silo/infra/ || { echo "Failed to copy files"; exit 1; }
rm -rf onboarded-tenants/silo/application/values.yaml.template


# Configure Git with user details
git config --global --unset credential.helper
git config --global credential.helper 'cache --timeout=900'
git config --global user.email 'devops@sourcefuse.com' || { echo "Failed to configure user email"; exit 1; }
git config --global user.name 'sfdevops' || { echo "Failed to configure user name"; exit 1; }

# Add and commit changes
if [ -n "$(git status --porcelain)" ]; then
    git add . || { echo "Failed to add files"; exit 1; }
    git commit -m 'Initial Commit' || { echo "Failed to commit changes"; exit 1; }
    git push ${GITHUB_REPO_URL} main || { echo "Failed to push changes"; exit 1; }
    echo "Changes committed and pushed successfully"
else
    echo "Nothing to commit, working tree clean. Exiting..."
fi

echo "Script executed successfully"