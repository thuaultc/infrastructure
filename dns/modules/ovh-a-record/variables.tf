variable "subdomain" {
  type        = "string"
  description = "Subdomain to assign to the A record"
}

variable "target" {
  type        = "string"
  description = "Target IP to assign to the A record"
  default     = "62.210.152.42"
}
