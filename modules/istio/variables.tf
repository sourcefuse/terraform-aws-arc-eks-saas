variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  default     = ""
  type        = string
}

##############################################################################
## ISTIO BASE CONFIGURATIONS 
##############################################################################

variable "istio_kiali_namespace" {
  description = "The namespace related to istio base"
  type        = string
  default     = "istio-system"
}

variable "istio_base_version" {
  description = "The version string related to istio base"
  type        = string
  default     = "1.19.6"
}

##############################################################################
## ISTIOD DEAMON OR DEPLOYMENT CONFIGURATIONS 
##############################################################################
variable "istiod_version" {
  description = "The version string related to istiod"
  type        = string
  default     = "1.19.6"
}
##############################################################################
## ISTIOD INGRESS CONFIGURATIONS 
##############################################################################

variable "istio_ingress_version" {
  description = "The version string related to istio ingress"
  type        = string
  default     = "1.19.6"
}


variable "istio_ingress_min_pods" {
  type        = number
  description = "The minimum number of pods to maintain for the Istio ingress gateway. This ensures basic availability and load handling."
  default     = 3
}

variable "istio_ingress_max_pods" {
  type        = number
  description = "The maximum number of pods to scale up for the Istio ingress gateway. This limits the resources used and manages the scaling behavior."
  default     = 9
}

##############################################################################
## KIALI CONFIGURATIONS 
##############################################################################  

variable "deploy_kiali" {
  description = "Determines if Kiali should be deployed"
  type        = bool
  default     = true
}

variable "kiali_server_version" {
  description = "The version string related to kiali-server"
  type        = string
  default     = "1.78.0"
}

variable "kiali_virtual_service_host" {
  type        = string
  description = "The hostname for the Kiali virtual service, a part of Istio's service mesh visualization. It provides insights into the mesh topology and performance."
  default     = "kiali.k8s.raj.ninja"
}


##############################################################################
## SELF SIGNED VARIABLE
##############################################################################

variable "validity_period_hours" {
  type        = number
  description = " Self Sign Certificate validity in hours."
  default     = 8760
}

variable "common_name" {
  type        = string
  description = " Domain Name  supplied as commn name."
  default     = ""
}

variable "organization" {
  type        = string
  description = " Organization name supplied as common name."
  default     = ""
}

variable "kubernetes_secret_istio" {
  type        = string
  description = "Istio kubernetes secret for self sign certificate"
  default     = "istio-cred"
}
