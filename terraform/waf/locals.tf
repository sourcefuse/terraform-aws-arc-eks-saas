locals {
  load_balancer_arn = [data.aws_lb.ingress_load_balancer.arn]
}