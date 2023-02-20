variable "environment" {
  description = "Deployment Environment"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "CIDR block for Private Subnet"
}

variable "region" {
  description = "Region in which the bastion host will be launched"
}

variable "availability_zones" {
  type        = list
  description = "AZ in which all the resources will be deployed"
}
variable "instance_ami" {
  type = string
  description = "The id of ami"
}
variable "instance_type"{
  type = string
  description = "The type of the instance"
}
variable "ssh_key_name" {
  type = string
  description = "The name of the pem key"
}
variable "kube_network_cfg" {
  type = string
  description = "The cidr of the kubernetes networking"
}
variable "ecr_name"{
  type = string
  description = "The name of the ecr"
}
variable "ecr_mutability"{
  type = string
  description = "Image tag mutability"
}
variable "eks_node_name" {
  type = string
  description = "The name of the nodegroup"
}
variable "node_disk" {
  type = string
  description = "The size of nodegroup disk"
}
variable "node_instance_type" {
  type = list
  description = "The size of the nodegroups"
}
variable "cluster_name"{
  type = string
  description = "The name of the eks cluster"
}
variable "cluster_version"{
  type = string
  description = "The version of the eks cluster"
}