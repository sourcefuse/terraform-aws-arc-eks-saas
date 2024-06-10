variable "length" {
  type        = number
  description = "The length of the string desired."
  default     = "1"
}

variable "is_special" {
  type        = bool
  description = "Include special characters in the result."
  default     = "true"
}

variable "is_lower" {
  type        = bool
  description = "Include lowercase alphabet characters in the result"
  default     = "true"
}

variable "is_upper" {
  type        = bool
  description = "Include uppercase alphabet characters in the result"
  default     = "true"
}

variable "is_numeric" {
  type        = bool
  description = "Include numeric characters in the result"
  default     = "true"
}

variable "override_special" {
  type        = string
  description = "Supply your own list of special characters to use for string generation"
  default     = ""
}

variable "min_lower" {
  type        = number
  description = "Minimum number of lowercase alphabet characters in the result"
  default     = 0
}

variable "min_upper" {
  type        = number
  description = "Minimum number of uppercase alphabet characters in the result"
  default     = 0
}

variable "min_numeric" {
  type        = number
  description = "Minimum number of numeric characters in the result"
  default     = 0
}

variable "min_special" {
  type        = number
  description = "Minimum number of special characters in the result"
  default     = 0
}