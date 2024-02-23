################################################################
## random
################################################################
resource "random_password" "password" {
  length           = var.length
  special          = var.is_special
  lower            = var.is_lower
  upper            = var.is_upper
  numeric          = var.is_numeric
  override_special = var.override_special
  min_lower        = var.min_lower
  min_upper        = var.min_upper
  min_numeric      = var.min_numeric
  min_special      = var.min_special
}