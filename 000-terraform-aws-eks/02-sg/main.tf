module "ingress" {
    source = "git::https://github.com/Satish-Kalari/rmodule-aws-sg.git?ref=master"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "ingress-controller"
    sg_description = "SG for ingress-controller" 
}

module "cluster" {
    source = "git::https://github.com/Satish-Kalari/rmodule-aws-sg.git?ref=master"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "eks-cluster"
    sg_description = "SG for eks-cluster"
}

module "node" {
    source = "git::https://github.com/Satish-Kalari/rmodule-aws-sg.git?ref=master"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "eks-node"
    sg_description = "SG for eks-node"
}

# cluster is accepting traffic from node on all port
resource "aws_security_group_rule" "cluster_node" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    source_security_group_id = module.node.sg_id
    security_group_id = module.cluster.sg_id  
}

# node is allowed to communicate/traffic from master on all ports
resource "aws_security_group_rule" "node_cluster" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    source_security_group_id = module.cluster.sg_id
    security_group_id = module.node.sg_id  
}

# nodes are accepting traffic on ephemeral ports from ingress-controller
resource "aws_security_group_rule" "node_ingress" {
    type = "ingress"
    from_port = 30000
    to_port = 32767
    protocol = "tcp"
    source_security_group_id = module.ingress.sg_id
    security_group_id = module.node.sg_id  
}