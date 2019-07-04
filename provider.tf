variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable image {}
variable region {}
variable size_cluster {}
variable connection_user {}
variable connection_type {}
variable connection_timeout {}

provider "digitalocean" {
  token = "${var.do_token}"
}
