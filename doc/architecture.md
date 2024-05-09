- [Introduction](#introduction)
- [The High-Level Architecture](#the-high-level-architecture)
  - [Tenant Onboarding](#tenant-onboarding)
  - [Tenant Isolation Models](#tenant-isolation-models)
- [AWS Architecture](#aws-architecture)
  - [EKS Cluster](#eks-cluster)
  - [Kubernetes Objects](#kubernetes-objects)
  - [Logging And Monitoring](#logging-and-monitoring)
  - [Billing](#billing)
- [Per-tenant Infrastructure](#per-tenant-infrastructure)
  - [Tenant Routing](#tenant-routing)
  - [Tenant Management](#tenant-management)

  


## Introduction

SourceFuse Reference Architecture to implement a EKS multi-tenant software-as-a-service (SaaS) solution. The purpose of this document is to give the architecture design specifics that will bring insight to how a Saas solution using **ARC** is structured, organized and works internally. SourceFuse has developed a demonstration EKS SaaS solution aimed at illustrating the key architectural and design principles essential for constructing a multi-tenant SaaS platform on AWS. This example serves as a practical reference for developers and architects seeking to implement best practices in their own projects. The programming model, cost efficiency, security, deployment, and operational attributes of EKS represent a compelling model for SaaS providers.

In the upcoming sections, we'll delve into the mechanics of this multi-tenant SaaS EKS solution setup. We'll dissect the fundamental architectural tactics employed to tackle issues for tenants such as isolation, identity management, data segmentation, routing efficiency, deployment workflows, tenant management and operational complexities inherent in crafting and delivering an EKS-based SaaS solution on AWS. Additionally, we've integrated a tailored observability stack for each tenant, encompassing monitoring and logging functionalities. Furthermore, we'll delve into the billing component of this SaaS solution, leveraging Kubecost and Grafana dashboards for comprehensive insights. This comprehensive exploration aims to furnish you with a hands-on comprehension of the entire system.

This document is intended for developers and architects who have experience on AWS, Terraform. A working knowledge of both Kubernetes and Docker is also helpful. 


## The High-Level Architecture

Before we delve into the specifics of the SaaS EKS solution, let's first examine the overarching elements of the architecture. In Figure 1, you'll find an overview of the foundational layers comprising the SaaS architecture environment.

![Figure 1 - High-level EKS SaaS Architecture](static/saas-high-level-arch.png)
Figure1 - High-level EKS SaaS Architecture

ARC SaaS architecture consists of two major layers at a high level - 

1. **Control Plane** - The control plane is foundational to any multi-tenant SaaS model. ARC SaaS control plane will include those services that give consumers the ability to manage and operate their tenants through a single, unified experience. Within the control plane, we have 3-tier architecture supporting UI (or some CLI), API and data separately. The core services here represent the collection of services that are used to orchestrate multi-tenant experience. We’ve included some of the common examples of services that are typically part of the core. However, these core services could vary for each SaaS solution depending on the requirements. In the architecture diagram above, we have also shown a separate administration application UI. This represents the application (a web application, a command line interface, or an API) that might be used by a SaaS provider to manage their multi-tenant environment. Please note that the control plane and its services are not actually multi-tenant. These services are global to all tenants and are basically used to operate and manage tenants.

2. **Application Plane** - At the bottom of the diagram, we have represented the application plane of a SaaS environment. This is where the multi-tenant functionality of the actual application will reside. Each tenant will have it's own application plane which will be deployed using helm package manager on EKS cluster.

Control plane services will be used for tenant onboarding and management. 

### Tenant Onboarding

Developing a seamless onboarding process is crucial for any SaaS offering. With EKS SaaS, our aim is to showcase a method for creating a streamlined onboarding experience that automatically handles the setup and deployment of required resources for every new user.

Within this solution, several components are involved in the onboarding procedure. It involves the creation of a fresh tenant and a corresponding user, the customization of the Kubernetes namespace for the tenant, and the deployment of application microservices specific to that tenant. By the conclusion of this process, all infrastructure and multi-tenant policies will be established for your tenants.

![Figure 2 - Tenant Onboarding](static/tenant-onboarding.png)
Figure2- Tenant Onboarding

Figure2 outlines the onboarding flow. It demonstrates how a new tenant will be onboarded to the multi-tenancy setup. Firstly, tenant will use signup/landing page or SaaS admin/control-plane can register the tenant based on the subscription plan. We have the tenant management service in control plane which will be responsible to update the tenant details in control plane tenant DB. Control access for the tenants will be managed through Amazon cognito. During the Onboarding process, an admin user will be created for each tenant in respective congito user pool. 

Based on the tenant type either it's pool or silo, we have separate codebuild project for provisioning a new tenant. Control plane will trigger the respective codebuild project which will deploy tenant related infrastructure and tenant application plane. As part of the tenant infrastructure, Each tenant will have it's own isolation policies, identity management, monitoring & logging etc. which we will explore in upcoming sections. 

**User Management Service** 

The user management service is used in two separate contexts: one for the SaaS application users and one for the administration application. The sample SaaS actually includes a tenant administration experience that illustrates the natural mechanism that you’d include in your SaaS product to manage your application’s users.

User management plays a more specific role during the onboarding of a new tenant. When a new tenant is created, user management will actually create the Cognito user pool and AppId for that tenant (this is a one-time operation for the tenant). This data is then updated in tenant management and used to support the authentication flow.

The administration application uses a separate user pool for administration users. A SaaS provider can use this application to add, update, and delete administration users.

**Landing Page** 

The landing page is a simple, anonymous sign-up page. It’s representative of our public-facing marketing page through which prospective tenants can sign-up. When you select the sign-up option, you will provide data about your new tenant and submit that information to the system’s registration service. This service will then create and configure all of the resources needed to introduce a new tenant into the system.

As part of this onboarding flow, the system will also send a verification email to the address that was provided during sign-up. The information in this email will allow you to access the system with a temporary password.


### Tenant Isolation Models

In general, SaaS applications can have tenant isolations at two major layers. First, the compute layer (EKS nodes, Lambda functions, etc.).

1. **Pooled Compute** - In case of EKS, pooled compute would mean each tenant will be sharing the same EC2 node on EKS for their backend microservices, but they can have separate namespace. In case of serverless, it would mean each tenant will be sharing the same lambda function per microservice.

2. **Siloed Compute** - In case of EKS, siloed compute would mean each tenant will have its own separate EC2 node on EKS within which all its backend microservices will be deployed. In case of serverless, it would mean each tenant will have its own lambda function deployed per microservice.

The second layer where we can have isolation is at the storage layer (Database, Cache,
Queues, etc.).

1. **Pooled Storage** - All the tenants data will be stored in the same database with logical separation implemented using tenant_id columns in each table in DB.
2. **Siloed Storage** - Each tenant will have its own independent storage unit. It can be a separate schema per tenant (within one database), separate databases per tenant (within one RDS/Aurora), or even separate RDS/Aurora.

As part of ARC SaaS, we will be supporting different multi-tenancy isolation models and its provisioning via control plane.
* Pooled Compute & Pooled Storage
* Siloed Compute & Siloed Storage

In this reference architecture solution, namespaces are used here to create a logical isolation boundary for the different tenants and their resources in an Amazon EKS cluster. We are using a namespace-per-tenant model and use it as a way to divide an EKS cluster’s resources across different tenants as part of the overall tenant isolation model. Once a namespace is created for a tenant, an IAM Role for Service Account is created and associated with the namespace, to further implement isolation strategies to secure the tenant’s application and workloads.

But, namespaces have no intrinsic network boundaries by default, and as a result integrating network policy solutions such as istio authorization policy enable you to achieve network isolation by applying fine-grained network policies at the namespace level.

As part of our overall tenant isolation story, we must also look at isolation is enforced as these tenant microservices attempt to access other resources. In the EKS SaaS solution we have illustrated how isolation is applied as our microservices in tenant namespace, are accessing data.

![Figure 3 - Tenant Isolation](static/tenant-isolation.png)
Figure3- Tenant Isolation

Figure3 descibes two level of different isolation. At the top of the diagram, you’ll see how we’ve attached istio authorization policies which will prevent access to resources in other tenant namespace. Secondly, We have attached service account role to each tenant namespace in the EKS cluster which do not have access to the secrets of other tenant stored in parameter store of system manager. In this way, each tenant can access to specific resources for it's own tenant.


## AWS Architecture

Having grasped the key concepts in motion, let's explore the underlying architecture and observe the tangible architectural elements formed during the setup of the SaaS EKS solution.

In the Figure4, We have described how multi-tenant SaaS solution is deployed on AWS. This infrastructure is comprised of the actual EKS cluster that hosts our service. It also includes the required supporting infrastructure, such as IAM, RDS, WAF, Cognito, S3 buckets, tenant provisioning codebuilds, monitoring and logging tools etc.

The entire solution is built and deployed using terraform infrastructure as a code (IAC). To deploy the each component of the AWS architecture, we have either used ARC IAC terraform modules or we have written the modules to avoid repeatable code.

We have configured codepipeline using terraform to deploy the complete control-plane infrastructure which will also deploy the microservices for control-plane/admin-plane. Please see the README.md file in the root directory of the repository for the rolling out multi-tenant EKS SAAS solution.

![Figure 4 - AWS Physical EKS SaaS Architecture](static/ARC-SaaS-AWS-Physical-Architecture.png)
Figure4 - AWS Physical EKS SaaS Architecture

The following is a breakdown of the key components of this baseline architecture.

### EKS Cluster

The EKS cluster, along with its corresponding VPC, subnets and NAT Gateways, is deployed via terraform IAC. The terraform scripts deploys a ready-to-use EKS cluster alongwith EKS addons like fluentbit, argocd, argo-workflow, karpenter etc. This cluster runs the pooled and the silo tenant environments of your EKS SaaS solution.

EKS addon helps with logging configuration using fluentbit, managing tenant compute resources using karpenter and tenant application management using argo gitops. We have also configured kuberhealthy operator for synthetic monitoring on EKS cluster.

All new tenant which will be onboarded to the system, will have separate namespace on cluster. Each namespace will have security policy and service account role attached to it.

We have configured istio service mesh for inter-service routing, failure recovery, load balancing and security. Tenant routing will be managed through istio. We have also implemented Kiali to configure, visualize, validate and troubleshoot the istio service mesh.


### Kubernetes Objects

During Control Plane IAC deployment, we also need to configure the Kubernetes objects that needed to support the needs of our SaaS environment. The baseline configuration call uses kubectl to configure and deploy these constructs. This kubernetes objects like istio authorization policy, karpenter nodepool & ec2nodeclass, kuberhealthy health check, virtual service, gateways etc will be deployed using helm package manager. 

We will also register each tenant application with argocd and tenant infrastructure workflow using argo-workflow using kubectl.

### Logging And Monitoring

We are using AWS Opensearch for storing logs of the control-plane microservices as well as we are managing per tenant wise logs. We are creating separate opensearch indexes based on kubernetes namespaces using lua fluentbit script. We are also creating opensearch user and index patterns for each tenant. Each tenant will have access to it's own index pattern and it can not access application logs of other tenant namespace. Tenant specific indexes and users will be created on the fly using tenant provisioning codebuild.

For monitoring, Mainly we are using Prometheus and Grafana. We have configured prometheus node-exporter and adot collector on EKS cluster to collect the metrices from naemspaces. These metrices can be visualised using Grafana dahsboards. We can visualize tenant wise API metrics as well. Here are some example of grafana Dashabords.

![Figure 5.1 - Grafana Dashboard1](static/monitoring/grafana-dashbaord1.png)
![Figure 5.2 - Grafana Dashboard2](static/monitoring/grafana-dashbaord2.png)
![Figure 5.3 - Grafana Dashboard3](static/monitoring/grafana-dashbaord3.png)
Figure5 - Grafana Dashboards


