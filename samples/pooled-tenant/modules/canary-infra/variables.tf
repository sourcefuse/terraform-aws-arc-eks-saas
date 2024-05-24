variable "vpc_id" {

}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs in which to execute the canary"
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign the resources."
}