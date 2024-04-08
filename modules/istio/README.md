<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 1.14 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.istio_base](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_ingress](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.kiali-server](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.kiali_gateway](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.kiali_virtual_service](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.istio-certificate-secret](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/secret) | resource |
| [local_file.certificate](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.private_key_rsc](https://registry.terraform.io/providers/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.signed_cert_rsc](https://registry.terraform.io/providers/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_name"></a> [common\_name](#input\_common\_name) | Domain Name  supplied as commn name. | `string` | `""` | no |
| <a name="input_deploy_kiali"></a> [deploy\_kiali](#input\_deploy\_kiali) | Determines if Kiali should be deployed | `bool` | `true` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | The name of the EKS cluster | `string` | `""` | no |
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | The version string related to istio base | `string` | `"1.19.6"` | no |
| <a name="input_istio_ingress_max_pods"></a> [istio\_ingress\_max\_pods](#input\_istio\_ingress\_max\_pods) | The maximum number of pods to scale up for the Istio ingress gateway. This limits the resources used and manages the scaling behavior. | `number` | `9` | no |
| <a name="input_istio_ingress_min_pods"></a> [istio\_ingress\_min\_pods](#input\_istio\_ingress\_min\_pods) | The minimum number of pods to maintain for the Istio ingress gateway. This ensures basic availability and load handling. | `number` | `3` | no |
| <a name="input_istio_ingress_version"></a> [istio\_ingress\_version](#input\_istio\_ingress\_version) | The version string related to istio ingress | `string` | `"1.19.6"` | no |
| <a name="input_istio_kiali_namespace"></a> [istio\_kiali\_namespace](#input\_istio\_kiali\_namespace) | The namespace related to istio base | `string` | `"istio-system"` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | The version string related to istiod | `string` | `"1.19.6"` | no |
| <a name="input_kiali_server_version"></a> [kiali\_server\_version](#input\_kiali\_server\_version) | The version string related to kiali-server | `string` | `"1.78.0"` | no |
| <a name="input_kiali_virtual_service_host"></a> [kiali\_virtual\_service\_host](#input\_kiali\_virtual\_service\_host) | The hostname for the Kiali virtual service, a part of Istio's service mesh visualization. It provides insights into the mesh topology and performance. | `string` | `"kiali.k8s.raj.ninja"` | no |
| <a name="input_kubernetes_secret_istio"></a> [kubernetes\_secret\_istio](#input\_kubernetes\_secret\_istio) | Istio kubernetes secret for self sign certificate | `string` | `"istio-cred"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization name supplied as common name. | `string` | `""` | no |
| <a name="input_validity_period_hours"></a> [validity\_period\_hours](#input\_validity\_period\_hours) | Self Sign Certificate validity in hours. | `number` | `8760` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate"></a> [certificate](#output\_certificate) | n/a |
| <a name="output_private_key"></a> [private\_key](#output\_private\_key) | n/a |
<!-- END_TF_DOCS -->