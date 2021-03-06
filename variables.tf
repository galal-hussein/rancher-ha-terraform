variable "name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "rancher_ssl_cert" {}
variable "rancher_ssl_key"  {}
variable "rancher_ssl_chain"  {}
variable "database_port"    {}
variable "database_name"    {}
variable "database_username" {}
variable "database_password" {}
variable "database_storage" {}
variable "database_instance_class" {}
variable "scale_min_size" {}
variable "scale_max_size" {}
variable "scale_desired_size" {}
variable "region" {}
variable "vpc_id" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "zone_id" {}
variable "fqdn" {}
variable "rancher_version" {}
variable "docker_version" {}
variable "rhel_selinux" {}
variable "rhel_docker_native" {}
variable "azs" {
  type = "list"
}

output "rancher_server_endpoint" {
  value = "https://${var.fqdn}"
}
