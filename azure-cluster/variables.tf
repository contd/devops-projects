//
variable "client_certificate_path" {
  type        = string
  description = "Path to client certificate (certificate.pfx)"
}
//
variable "client_certificate_password" {
  type        = string
  description = "Client certificate password"
}
//
variable "subscription_id" {
  type        = string
  description = "Subscription id"
}
//
variable "client_id" {
  type        = string
  description = "Client Id"
}
variable "client_secret" {
  type        = string
  description = "Client secret (password)"
}
//
variable "tenant_id" {
  type        = string
  description = "Tenant Id"
}
// Region to build into
variable "location" {
  type        = string
  description = "Location or region"
}
//
variable "cluster_name" {
  type        = string
  description = "Name of the kubernetes cluster"
}
