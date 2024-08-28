# SourceFuse ARC EKS SAAS Reference Architecture

<p align="center">
  <a href="https://sourcefuse.github.io/arc-docs/arc-api-docs" target="blank"><img src="https://github.com/sourcefuse/arc-saas/blob/master/docs/assets/logo-dark-bg.png?raw=true" width="180" alt="ARC Logo" /></a>
</p>

<p align="center">
  With ARC SaaS, we’re introducing a pioneering SaaS factory model based control plane microservices and IaC modules that promises to revolutionize your SaaS journey.
</p>

<p align="center">
<a href="https://sonarcloud.io/summary/new_code?id=sourcefuse_terraform-aws-arc-eks-saas" target="_blank">
<img alt="Quality Gate Status" src="https://sonarcloud.io/api/project_badges/measure?project=sourcefuse_terraform-aws-arc-eks-saas&metric=alert_status&token=753087a003438b8bb11e624ea44302d9044d428e">
</a>
<a href="https://app.snyk.io/org/ashishkaushik/reporting?context[page]=issues-detail&project_target=%255B%2522sourcefuse%252Fterraform-aws-arc-eks-saas%2522%255D&project_origin=%255B%2522github%2522%255D&issue_status=%255B%2522Open%2522%255D&issue_by=Severity&table_issues_detail_cols=SCORE%257CCVE%257CCWE%257CPROJECT%257CEXPLOIT%2520MATURITY%257CAUTO%2520FIXABLE%257CINTRODUCED%257CSNYK%2520PRODUCT&v=1">
<img alt="Synk" src="https://github.com/sourcefuse/terraform-aws-arc-eks-saas/actions/workflows/synk.yaml/badge.svg">
</a>
<a href="./LICENSE">
<img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License" />
</a>

</p>


# Overview

SourceFuse Reference Architecture to implement a sample EKS Multi-Tenant SaaS Solution. This solution will use AWS Codepipeline to deploy all the control plane infrastructure component of Networking, Compute, Database, Monitoring & Logging and Security alongwith the control plane application using helm chart. This solution will also setup tenant codebuild projects which is responsible for onboarding of new silo and pooled tenant. Each tenant will have it's own infrastructure and application helm chart Which will be managed using gitops tool like ArgoCD and Argo Workflow. This solution will also have strict IAM policy and Kubernetes Authorization Policy for tenants to avoid cross namespace access.

For more details, you can go through the [eks saas architecture documentation](docs/eks-saas-architecture.md).

## Requirements

1. AWS Account 
2. Terraform CLI
3. AWS CLI


## Pre-Requisitie

> :warning: Please ensure you are logged into AWS Account as an IAM user with Administrator privileges, not the root account user.

1. If you don't have registered domain in Route53 then [register domain in Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html). (If you have domain registered with 3rd party registrars then [create hosted zone on route53](https://medium.com/weekly-webtips/how-to-integrate-3rd-party-domain-names-with-aws-route-53-for-your-website-webapp-7f6cd8ff36b6) for your domain.)
2. Generate Public Certificate for the domain using [AWS ACM](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html). (please ensure to give both wildcard and root domain in Fully qualified domain name while generating ACM, e.g. if domain name is xyz.com then use both xyz.com & *.xyz.com in ACM)
3. SES account should be setup in production mode and `domain` should be verified. [Generate smtp credentials](https://docs.aws.amazon.com/ses/latest/dg/smtp-credentials.html) and store them in ssm parameter store as `SecureString`. (using parameter name - /{namespace}/ses_access_key & /{namespace}/ses_secret_access_key where `namespace` is project name)
4. [Generate Github Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)and store them in ssm parameter as `SecureString`. (using parameter name - /github_user & /github_token)
> **_NOTE:_** If you are using organization github account then create github token with organization scope and provide necessary permission to create, manage repository & merge into the repository. Otherwise you can create github token for your personal user. Update the `.tfvars` file of `terraform/tenant-codebuilds` folder.

5. Create a [codepipeline connection for github](https://docs.aws.amazon.com/codepipeline/latest/userguide/connections-github.html) with your github account and repository.
6. If you want to use client-vpn to access opensearch dashboard then enable it using variable defined in `.tfvars` file of `terraform/client-vpn` folder. [follow [doc](doc/client-vpn-connection.md) to connect with VPN ]

6. We are using pubnub and vonage credentials for the application plane and we have stored them in parameter store so if you want to use the same application plane then create your own credentials and store them in parameter store. Please check application helm chart and values.yaml.template file stored in `files/tenant-samples` folder for pubnub configuration.


## Setting up the environment

* First clone/fork the Github repository. 
* Based on the requirements, change `terraform.tfvars` file in all the terraform folders.
* Update the variables **namespace**,**environment**,**region**,**domain_name** in the `script/replace-variable.sh` file.
* Execute the script using command `./scripts/replace-variable.sh`
* Execute the script for pushing decoupling orchestrator image to ECR repository using command `./scripts/push-orchestrator-image.sh`
* Update the codepipeline connection name (created in pre-requisite section), github repository name and other required variables in `terraform.tfvars` file of `terraform/core-infra-pipeline folder`.
* Check if **AWSServiceRoleForAmazonOpenSearchService** Role is already created in your AWS account then set `create_iam_service_linked_role` variables to false in tfvars file of `terraform/opensearch` otherwise set it to true.
* Update the ACM ((created in pre-requisite section)) ARN in `terraform.tfvars` file of terraform/istio folder.
* Go thorugh all the variables decalred in tfvars file and update the variables according to your requirement.


Once the variables are updated, We will setup terraform codepipeline which will deploy all control plane infrastructure components alongwith control plane helm. We have multiple option to do that - 

1. Using Github Actions :: 

> **_NOTE:_** We are using slef hosted github runners to execute workflow action. please follow [this](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) document to setup runners.

* First create an [IAM role for github workflow actions](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/) and update the role name and other required variables like environment etc. in workflow yaml files defined under `.github` directory.
* Add **AWS_ACCOUNT_ID** in [github repository secret](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions).
* Execute the workflow of *apply-bootstrap.yaml* & *apply-pipeline.yaml* by updating the github events in these files. Currently these workflows will be executed when pull request will be merged to main branch so change the invocation of these workflow files according to you.
* Push the code to your github repository.


> **_NOTE:_** If you want to run other workflows, which are terraform plans, make sure to update the workflow files. Terraform bootstrap is one time activity so once bootstrap workflow is executed, please disable that to run again.


2. Using Local ::

AWS CLI version2 & Terraform CLI version 1.7 must be installed on your machine. If not installed, then follow the documentation to install [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) & [terraform cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

* Configure your terminal with aws.
* Go to the `terraform/bootstrap` folder and run the floowing command to deploy it - 

    ```
    terraform init
    terraform plan 
    terraform apply
    ```
* After that, Go to the `terraform/core-infra-pipeline` and update the bucket name, dynamodb table name (created in above step) and region in `config.hcl`. 

**_NOTE:_** Update `config.hcl` file based using s

* Push the code to your github repository.
* Run the Followign command to create terraform codepipeline - 

    ```
    terraform init --backend-config=config.hcl
    terraform plan
    terraform apply 
    ```
> **_NOTE:_** All Terraform module README files are present in respective folder.


Once the codepipeline is created, Monitor the pipeline and when Codepipeline is executed successfully then create the following records in route53 hosted zone of the domain, using Load Balancer DNS address.

| Record Entry                   | Type   | Description                     |
|--------------------------------|--------|---------------------------------|
| {domain-name}                  |   A    | control-plane application URL.  |
| argocd.{domain-name}           | CNAME  | ArgoCD URL                      |
| argo-workflow.{domain-name}    | CNAME  | Argo Workflow URL               |
| grafana.{domain-name}          | CNAME  | Grafana Dashboard URL           |

> **_NOTE:_** All authentication password will be saved in SSM Paramater store. On Grafana, Please add athena, cloudwatch and prometheus data source and import the dashboard using json mentioned in billing and observability folder. 

After Creating record in the Route53, you can access the control plane application using `{domain-name}` URL (eg. if your domain name is xyz.com then control plane will be accessible on xyz.com). Tenant onboarding can be done using the URL `{domain-name}/tenant/signup`. Once the tenant will be onboarded successfully then you can access the tenant application plane on URL `{tenant-key}.{domain-name}`


## Authors

This project is authored by below people

- SourceFuse ARC Team


## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

