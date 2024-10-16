
resource "local_file" "keycloak_gateway" {
  content  = <<-EOT
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: keycloak
  namespace: ${local.kubernetes_ns}
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "keycloak.${var.domain_name}"
    EOT
  filename = "${path.module}/keycloak-manifest-files/keycloak_gateway.yaml"
}





resource "local_file" "keycloak_virtual_service" {
  content  = <<-EOT
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: keycloak
  namespace: ${local.kubernetes_ns}
spec:
  hosts:
    - "keycloak.${var.domain_name}"
  gateways:
    - keycloak
  http:
    - match:
        - uri:
            prefix: /
      route:
        - destination:
            host: keycloak
            port:
              number: 80
    EOT
  filename = "${path.module}/keycloak-manifest-files/keycloak_virtual_service.yaml"
}
