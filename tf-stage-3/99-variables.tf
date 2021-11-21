variable "dnszone" {
  description = "Azure DNS zone name"
}

variable "subdomain" {
  description = "The subdomain this cluster will serve"
  default = "demo"
}

variable "email" {
  description = "Email address where letsencrypt will report certificate activities"
}