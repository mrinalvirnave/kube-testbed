variable "dnszone" {
  description = "Azure DNS zone name"
}

variable "domain" {
  description = "Main domain this cluster will serve"
  default = "demo"
}