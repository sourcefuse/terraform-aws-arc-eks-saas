
resource "local_file" "grafana_gateway" {
  content  = <<-EOT
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: grafana
  namespace: ${var.grafana_namespace}
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "grafana.${var.domain_name}"
    EOT
  filename = "${path.module}/grafana-manifest-files/grafana_gateway.yaml"
}





resource "local_file" "grafana_virtual_service" {
  content  = <<-EOT
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: grafana
  namespace: ${var.grafana_namespace}
spec:
  hosts:
    - "grafana.${var.domain_name}"
  gateways:
    - grafana 
  http:
    - match:
        - uri:
            prefix: /
      route:
        - destination:
            host: "grafana"
            port:
              number: 80
    EOT
  filename = "${path.module}/grafana-manifest-files/grafana_virtual_service.yaml"
}
