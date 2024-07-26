#!/bin/bash
NAMESPACE=
ENVIRONMENT=
REGION=us-east-1

REPO_NAME="$NAMESPACE-$ENVIRONMENT-orchestration-service-repository"
IMAGE_URI="public.ecr.aws/p1a1c8p2/sourcefuse-arc-saas-control-plane-orchestration-service:latest"
TAGGED_IMAGE="$REPO_NAME:0.0.1"
SSM_PARAMETER_NAME="/$NAMESPACE/$ENVIRONMENT/orchestration-ecr-image-uri"

# Create ECR repository if it does not exist
aws ecr describe-repositories --repository-names "$REPO_NAME" --region "$REGION" > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Creating ECR repository: $REPO_NAME"
  aws ecr create-repository --repository-name "$REPO_NAME" --region "$REGION"
else
  echo "ECR repository $REPO_NAME already exists."
fi

# Get the ECR repository URI
REPOSITORY_URI=$(aws ecr describe-repositories --repository-names "$REPO_NAME" --region "$REGION" --query 'repositories[0].repositoryUri' --output text)

# Pull the Docker image from the public repo
echo "Pulling image $IMAGE_URI"
docker pull "$IMAGE_URI"

# Tag the Docker image
echo "Tagging image as $REPOSITORY_URI:0.0.1"
docker tag "$IMAGE_URI" "$REPOSITORY_URI:0.0.1"

# Authenticate Docker to ECR
echo "Authenticating Docker to ECR"
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REPOSITORY_URI"

# Push the Docker image to the private ECR
echo "Pushing image to ECR"
docker push "$REPOSITORY_URI:0.0.1"

echo "Image pushed successfully: $REPOSITORY_URI:0.0.1"

# Store the image URI in SSM Parameter Store
SSM_IMAGE_URI="$REPOSITORY_URI:0.0.1"
echo "Storing image URI in SSM Parameter Store: $SSM_PARAMETER_NAME"
aws ssm put-parameter --name "$SSM_PARAMETER_NAME" --value "$SSM_IMAGE_URI" --type "String" --overwrite --region "$REGION"

echo "Image URI stored successfully in SSM Parameter Store: $SSM_PARAMETER_NAME"