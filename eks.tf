provider "kubernetes" {
        load_config_file=false

        host                   =data.aws_eks_cluster.myapp.endpoint
        token=data.aws_eks_cluster_auth.myapp.token
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp.certificate_authority[0].data)
  
}


data "aws_eks_cluster" "myapp" {
  name=module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "myapp" {
   name=module.eks.cluster_name
   depends_on = [module.eks]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  name               = "myapp-eks-cluster"
  kubernetes_version = "1.29"

  vpc_id     = module.myapp-vpc.vpc_id
  subnet_ids = module.myapp-vpc.private_subnets

  tags = {
    Environment = "development"
    application="myapp"
  }


eks_managed_node_groups = {
    worker_group_1 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    worker_group_2 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

}

