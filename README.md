# SourceFuse ARC EKS SAAS Reference Architecture

<p align="center">
<a href="https://sonarcloud.io/api/project_badges/measure?project=sourcefuse_terraform-aws-arc-eks-saas&metric=alert_status&token=753087a003438b8bb11e624ea44302d9044d428e">
</a>
</p>

<!-- [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=sourcefuse_terraform-aws-arc-eks-saas&metric=alert_status&token=753087a003438b8bb11e624ea44302d9044d428e)](https://sonarcloud.io/summary/new_code?id=sourcefuse_terraform-aws-arc-eks-saas) -->

[![snyk](https://github.com/sourcefuse/terraform-aws-arc-eks-saas/actions/workflows/synk.yaml/badge.svg)](https://github.com/sourcefuse/terraform-aws-arc-eks-saas/actions/workflows/synk.yaml)

# Overview

SourceFuse Reference Architecture to implement a sample EKS SaaS Solution. This solution will use AWS Codepipeline to deploy all the control plane infrastructure component of Networking, Compute, Database, Monitoring & Logging, Security alongwith the control plane application using helm chart. This solution will also setup tenant codebuild projects which is responsible for onboarding of new silo/pooled tenant. Each tenant will have it's own infrastructure and application helm chart Which will be managed using gitops tool like ArgoCD and Argo Workflow. This solution will also have strict IAM policy and Kubernetes Authorization Policy for tenants to avoid cross namespace access. 

## Requirements

1. AWS Account 
2. Terraform CLI
3. AWS CLI


## Pre-Requisitie

> :warning: Please ensure you are logged into AWS Account as an IAM user with Administrator privileges, not the root account user.

1. If you don't have registered domain in Route53 then [configure domain in Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html).
2. Generate Public Certificate for the domain using [AWS ACM](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html). (please ensure to give both wildcard and root domain in Fully qualified domain name while generating ACM, e.g. if domain name is xyz.com then use both xyz.com & *.xyz.com in ACM)
3. SES account should be setup in production mode and domain identity should be verified. [Generate smtp credentials](https://docs.aws.amazon.com/ses/latest/dg/smtp-credentials.html) and store them in ssm parameter store. (using parameter name - /{namespace}/ses_access_key & /{namespace}/ses_secret_access_key where **namespace** is project name)
4. [Generate http credentials](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-gc.html#setting-up-gc-iam) for your IAM user and store them in ssm parameter. (using parameter name - /{namespace}/https_connection_user & /{namespace}/https_connection_password where **namespace** is project name)
5. Create a [codepipeline connection for github](https://docs.aws.amazon.com/codepipeline/latest/userguide/connections-github.html). Please make sure to update the connection name in **tfvars** file of terraform/core-infra-pipeline folder.
6. If you want to use client-vpn to access opensearch dashboard then enable it using variable defined in **.tfvars** file of client-vpn folder.


## Setting up the environment

First clone the Github repository. Update the variables like **namespace**,**environment**,**region**,**domain_name** etc. in the respective *tfvars* file of terraform folder. Also, make sure to update the variables in the script files of terraform/tenant-codebuilds folder.

Once the required variables are updated, We will setup terraform codepipeline which will deploy all control plane infrastructure components.

1. Using Github Actions :: 

To use github action workflow,

* First create an [IAM role for github workflow actions](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/) and update the role name and other required variables like environment etc. in workflow yaml files.
* Add **AWS_ACCOUNT_ID** in [github repository secret](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions).
* Next, Make sure to update the environment variable in *scripts/update-backend-config.sh* file.
* Execute the workflow of *apply-bootstrap.yaml* & *apply-pipeline.yaml* by updating the github events in these files.


> **_NOTE:_** If you want to run other workflows, which are terraform plans, please make sure to update the workflows files. Terraform bootstrap is one time activity so once bootstrap workflow is executed, please disable that to run again.


2. Using Local ::

AWS & Terraform CLI latest version must be installed on your machine. If not installed, then follow the documentation to install [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) & [terraform cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

    a. Configure your terminal with aws.
    b. Go to the terraform/bootstrap folder and run the floowing command to deploy it - 

    ```
    terraform init
    terraform plan --var-file={env}.tfvars
    terraform apply --var-file={env}.tfvars

    ```
    c. Now, Go to the terraform/core-infra-pipeline and update the *config.{env}.hcl* with bucket and dynamodb table name, created in above step. 
    d. Run the Followign command to create terraform codepipeline - 

    ```
    terraform init --backend-config=config.{env}.hcl
    terraform plan --var-file={env}.tfvars
    terraform apply --var-file={env}.tfvars

    ```
> **_NOTE:_** All Terraform module README files are present in respective folder.


once the codepipeline is created then when you will merge code to main branch it will be triggered and once it is executed successfully then register the following entry in route53 hosted zone of the domain, using Load Balancer DNS address.

| Record Entry          | Description                     |
|-----------------------|---------------------------------|
| {domain-name}         | control-plane application URL.  |
| argocd.{domain-name}  | ArgoCD URL                      |
| argo.{domain-name}    | Argo Workflow URL               |
| billing.{domain-name} | Kubecost Dashboard URL          |
| grafana.{domain-name} | Grafana Dashboard URL           |

> **_NOTE:_** All authentication password will be saved in SSM Paramater store.



## Authors

This project is authored by below people

- SourceFuse ARC Team



