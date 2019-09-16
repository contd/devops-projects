variable "token" {
  type = "string"
  description = "DO Token: export DIGITALOCEAN_TOKEN=XXXXXXXXX"
}
variable "ssh_key_name" {
  type = "string"
  description = "Name of the ssh key stored on DO"
}
variable "region" {
  type = "string"
  description = "DO Region to use."
}
variable "cluster_name" {
  type = "string"
  description = "Name of Main Kubernetes cluster"
}
variable "cluster_version" {
  type = "string"
  description = "Version of Kubernetes to use"
}
variable "node_pool_name" {
  type = "string"
  description = "Name of the Kubernetes node pool"
}
variable "node_pool_size" {
  type = "string"
  description = "Size of the Kubernetes node pool"
}
variable "number_nodes" {
  type = "string"
  description = "Number of Droplets in node pool"
}
variable "domains" {
  type = "map"
  description = "Map of Domains so can itter. get their info"
  default = {
    kumpf = "kumpf.io"
    jason = "jasonkumpf.com"
  }
}
