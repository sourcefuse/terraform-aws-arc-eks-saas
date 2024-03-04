########################################################################
## data lookup
########################################################################
data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.eks_cluster_name
}

########################################################################
## istio
########################################################################
resource "helm_release" "istio_base" {
  name             = "istio-base"
  chart            = "base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = var.istio_kiali_namespace
  create_namespace = true

  version = var.istio_base_version

  depends_on = [
    data.aws_eks_cluster.eks_cluster
  ]
}

resource "helm_release" "istiod" {
  name             = "istio"
  chart            = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = var.istio_kiali_namespace
  create_namespace = true

  version = var.istiod_version

  depends_on = [
    data.aws_eks_cluster.eks_cluster,
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress" {
  name             = "istio-ingressgateway"
  chart            = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = var.istio_kiali_namespace
  create_namespace = true

  version = var.istio_ingress_version

  set {
    name  = "service.type"
    value = "NodePort"
  }


  set {
    name  = "autoscaling.minReplicas"
    value = var.istio_ingress_min_pods
  }

  set {
    name  = "autoscaling.maxReplicas"
    value = var.istio_ingress_max_pods
  }

  set {
    name  = "service.ports[0].name"
    value = "status-port"
  }

  set {
    name  = "service.ports[0].port"
    value = 15021
  }

  set {
    name  = "service.ports[0].targetPort"
    value = 15021
  }

  set {
    name  = "service.ports[0].nodePort"
    value = 30021
  }

  set {
    name  = "service.ports[0].protocol"
    value = "TCP"
  }


  set {
    name  = "service.ports[1].name"
    value = "http2"
  }

  set {
    name  = "service.ports[1].port"
    value = 80
  }

  set {
    name  = "service.ports[1].targetPort"
    value = 80
  }

  set {
    name  = "service.ports[1].nodePort"
    value = 30080
  }

  set {
    name  = "service.ports[1].protocol"
    value = "TCP"
  }


  set {
    name  = "service.ports[2].name"
    value = "https"
  }

  set {
    name  = "service.ports[2].port"
    value = 443
  }

  set {
    name  = "service.ports[2].targetPort"
    value = 443
  }

  set {
    name  = "service.ports[2].nodePort"
    value = 30443
  }

  set {
    name  = "service.ports[2].protocol"
    value = "TCP"
  }

  depends_on = [
    data.aws_eks_cluster.eks_cluster,
    helm_release.istio_base,
    helm_release.istiod
  ]
}


resource "helm_release" "kiali-server" {

  count = var.deploy_kiali ? 1 : 0


  name             = "kiali-server"
  chart            = "kiali-server"
  repository       = "https://kiali.org/helm-charts"
  namespace        = var.istio_kiali_namespace
  create_namespace = true

  version = var.kiali_server_version

  set {
    name  = "auth.strategy"
    value = "anonymous"
  }

  set {
    name  = "external_services.tracing.enabled"
    value = true
  }

  set {
    name  = "external_services.tracing.use_grpc"
    value = false
  }


  depends_on = [
    data.aws_eks_cluster.eks_cluster,
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubectl_manifest" "kiali_gateway" {


  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kiali-gateway
  namespace: ${var.istio_kiali_namespace}
spec:
  selector:
    istio: ingressgateway 
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "kiali.${var.common_name}"
YAML


  count = var.deploy_kiali ? 1 : 0


  depends_on = [
    data.aws_eks_cluster.eks_cluster,
    helm_release.istio_base,
    helm_release.istiod
  ]

}

resource "kubectl_manifest" "kiali_virtual_service" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: kiali
  namespace: ${var.istio_kiali_namespace}
spec:
  hosts:
  - "kiali.${var.common_name}"
  gateways:
  - kiali-gateway
  http:
  - match:
    - uri:
        prefix: /kiali
    route:
    - destination:
        host: kiali
        port:
          number: 20001
YAML


  count = var.deploy_kiali ? 1 : 0

  depends_on = [
    data.aws_eks_cluster.eks_cluster,
    helm_release.istio_base,
    helm_release.istiod
  ]

}

