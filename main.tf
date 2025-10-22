data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets  = [for i in range(2, 4) : cidrsubnet(var.vpc_cidr, 8, i)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true
  enable_dns_support     = true

  public_subnet_tags = merge(var.public_subnet_tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })

  private_subnet_tags = merge(var.private_subnet_tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name    = var.cluster_name
  cluster_version = var.eks_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  enable_irsa                     = true
  cluster_endpoint_public_access  = true

  eks_managed_node_groups = {
    default = {
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      ssh_key_name = var.enable_ssh ? var.ssh_key_name : null

      tags = {
        Name = "${var.cluster_name}-node"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}