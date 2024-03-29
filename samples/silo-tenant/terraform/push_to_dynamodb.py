import boto3
import os

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name=os.environ['AWS_REGION'])

# Define the table name
table_name = 'arc-saas-dev-tenant-terraform-details'

# Access environment variables from CodeBuild
environment_variables = os.environ

# Remove CodeBuild-specific environment variables
environment_variables.pop('CODEBUILD_SRC_DIR', None)
environment_variables.pop('CODEBUILD_RESOLVED_SOURCE_VERSION', None)
environment_variables.pop('CODEBUILD_START_TIME', None)
environment_variables.pop('CODEBUILD_BUILD_SUCCEEDING', None)
environment_variables.pop('CODEBUILD_INITIATOR', None)
environment_variables.pop('CODEBUILD_BUILD_NUMBER', None)
environment_variables.pop('CODEBUILD_BUILD_ID', None)
environment_variables.pop('AWS_DEFAULT_REGION', None)
environment_variables.pop('AWS_REGION', None)

# Push data to DynamoDB
table = dynamodb.Table(table_name)
for key, value in environment_variables.items():
    response = table.put_item(
        Item={
            'TENANT_ID': key,  # Assuming you want to use the environment variable name as the primary key
            'value': value,
            'type': os.environ.get(f'{key}_TYPE', 'PLAINTEXT')
        }
    )

    print(response)
