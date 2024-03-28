
# Add annotation - alb.ingress.kubernetes.io/wafv2-acl-arn for adding WAF - https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.1/guide/ingress/annotations/#addons
resource "local_file" "k8s_ingress" {
  content  = <<-EOT
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: alb-external-ingress
  namespace: istio-system
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}, {"HTTP":80}]'
    alb.ingress.kubernetes.io/load-balancer-name: ${var.alb_ingress_name}
    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/certificate-arn: ${var.acm_certificate_arn} 
  labels:
    app: alb-external-ingress
spec:
  rules:
    - host: "${var.full_domain_name}"
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: istio-ingressgateway
                port:
                  number: 80
    EOT
  filename = "${path.module}/manifest-files/k8s_ingress.yaml"
}





resource "local_file" "istio_gateway" {
  content  = <<-EOT
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: istio-ingressgateway
  namespace: istio-system
  labels:
    app: istio-ingressgateway
    istio: ingressgateway
    release: istio
spec:
  selector:
    istio: ingressgateway
  servers:
    - port:
        number: 80
        protocol: HTTP
        name: http
      hosts:
        - "*"
    - port:
        number: 443
        protocol: HTTPS
        name: https-default
      tls:
        mode: SIMPLE
        credentialName: istio-cred
      hosts:
        - "*"
    EOT
  filename = "${path.module}/manifest-files/istio_gateway.yaml"
}
