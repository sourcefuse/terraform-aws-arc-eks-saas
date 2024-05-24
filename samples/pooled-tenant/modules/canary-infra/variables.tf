variable "vpc_id" {
  
}

variable "subnet_ids" {
  type = list(string)
  description = "Subnet IDs in which to execute the canary"
}