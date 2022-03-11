data "aws_iam_role" "admin" {
  name = "test-admin"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      asg_desired_capacity          = 2
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]

  node_groups = {
    containerd = {
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 3
      additional_tags  = local.tags

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      update_config = {
        max_unavailable_percentage = 50
      }

      create_launch_template = true
      ami_type               = "AL2_x86_64"
      bootstrap_env = {
        CONTAINER_RUNTIME = "containerd"
      }
    }
  }

  map_roles = [
    {
      rolearn  = data.aws_iam_role.admin.arn
      username = data.aws_iam_role.admin.id
      groups   = ["system:masters"]
    }
  ]

  map_users = [
    {
      userarn  = "arn:aws:iam::039653571618:user/adamc"
      username = "adamc"
      groups   = ["system:masters"]
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
