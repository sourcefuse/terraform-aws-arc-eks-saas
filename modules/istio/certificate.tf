resource "tls_private_key" "private_key_rsc" {
  algorithm = "RSA"
}


resource "tls_self_signed_cert" "signed_cert_rsc" {
  key_algorithm   = tls_private_key.private_key_rsc.algorithm
  private_key_pem = tls_private_key.private_key_rsc.private_key_pem

  subject {
    common_name  = var.common_name
    organization = var.organization
  }

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}


resource "local_file" "private_key" {
  content  = tls_private_key.private_key_rsc.private_key_pem
  filename = "${path.module}/private_key.pem"
}

resource "local_file" "certificate" {
  content  = tls_self_signed_cert.signed_cert_rsc.cert_pem
  filename = "${path.module}/certificate.pem"
}


output "private_key" {
  sensitive = true
  value     = tls_private_key.private_key_rsc.private_key_pem
}

output "certificate" {
  sensitive = true
  value     = tls_self_signed_cert.signed_cert_rsc.cert_pem
}



resource "kubernetes_secret" "istio-certificate-secret" {
  metadata {
    name      = var.kubernetes_secret_istio
    namespace = var.istio_kiali_namespace
  }

  data = {
    "tls.crt" = tls_self_signed_cert.signed_cert_rsc.cert_pem
    "tls.key" = tls_private_key.private_key_rsc.private_key_pem
  }

  type       = "kubernetes.io/tls"
  depends_on = [resource.helm_release.istiod]
}





