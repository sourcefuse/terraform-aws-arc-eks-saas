import boto3
import os

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name=os.environ['AWS_REGION'])

# Define the table name
table_name = 'arc-saas-dev-tenant-terraform-details'

# Access environment variables from CodeBuild
environment_variables = os.environ

# Get the TENANT_ID
tenant_id = environment_variables.get('TENANT_ID', 'unknown')

# Remove CodeBuild-specific environment variables if needed
# Add code if any specific variables need to be excluded

# Push data to DynamoDB
table = dynamodb.Table(table_name)
for key, value in environment_variables.items():
    response = table.put_item(
        Item={
            'TENANT_ID': tenant_id,  # Mapping each variable to TENANT_ID
            'variable_name': key,
            'value': value
        }
    )

    print(response)
