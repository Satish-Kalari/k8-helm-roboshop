module "eks" {
  source = "terraform-aws-modules/eks/aws"
    version = "~> 20.0"
    cluster_name = "roboshop-tf-eks"
    cluster_version = "1.27"

    cluster_endpoint_public_access = true

    vpc_id = local.vpc_id
    subnet_ids = split(",", local.private_subnet_ids)
    control_plane_subnet_ids = split(",", local.private_subnet_ids)

    create_cluster_security_group = false
    cluster_security_group_id = local.cluster_sg_id

    create_node_security_group = false
    node_security_group_id = local.node_sg_id

    enable_cluster_creator_admin_permissions = true

    eks_managed_node_group_defaults = {
      instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
      
    }

    eks_managed_node_groups = {
      blue = {
        min_size = 2
        max_size = 10
        desired_size = 2
        instance_type = "SPOT"
        iam_role_additional_policies = {
            AmazonEBSCSIDriverpolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSSCSIDriverPolicy"
            AmazonElasticFileSystemClientPolicy = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
        }
    }   
    #   green = {
    #     min_size = 2
    #     max_size = 10
    #     desired_size = 2
    #     instance_type = "SPOT"
    #     iam_role_additional_policies = {
    #         AmazonEBSCSIDriverpolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSSCSIDriverPolicy"
    #         AmazonElasticFileSystemClientPolicy = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
    #     } 
    # }
}
tags = var.common_tags
}