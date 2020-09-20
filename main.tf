

# Datasources

# DataSource para sacar AZs disponibles
data "aws_availability_zones" "azs_available" {
  state = "available"
}


# Locals
locals {
  internet = "0.0.0.0/0"
}


# Crea VPC
resource "aws_vpc" "vpc_new" {
  cidr_block = lookup(var.vpc_options, "cidr_block")

  # DNS Support
  enable_dns_hostnames = lookup(var.vpc_options, "enable_dns_hostnames")
  enable_dns_support   = lookup(var.vpc_options, "enable_dns_support")

  instance_tenancy = lookup(var.vpc_options, "instance_tenancy")

}


# Internet Gateway
resource "aws_internet_gateway" "vpc_igw" {

  # Si la variable crea_igw es true entonces crearemos un igw en el vpc
  count = var.crea_igw ? 1 : 0

  vpc_id = aws_vpc.vpc_new.id

}


# Default route table
resource "aws_default_route_table" "rt_default_privada" {
  default_route_table_id = aws_vpc.vpc_new.default_route_table_id

}


# Public route table con salida a internet si hemos creado un igw
resource "aws_route_table" "rt_public" {

  count = var.crea_igw ? 1 : 0

  vpc_id = aws_vpc.vpc_new.id

  route {
    cidr_block = local.internet
    #gateway_id = length(aws_internet_gateway.vpc_igw) > 0 ? ["${aws_internet_gateway.vpc_igw[0].id}"] : null
    gateway_id = aws_internet_gateway.vpc_igw[0].id
  }

}
