// Create EKS IAM role

resource "aws_iam_role" "eks_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        }
      }
    ]
  }
POLICY
}

// IAM policy attachment

resource "aws_iam_role_policy_attachment" "eks_policy_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

// EKS Cluster Initialization

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    subnet_ids         = flatten([var.private_subnets_id, var.private_subnets_id])
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy_attach,
  ]

  tags = {
    Name       = "Nurkhat"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "True"
  }
}

// Create EKS nodes IAM Role

resource "aws_iam_role" "eks_nodes_role" {
  name = "${var.project_name}-eks-nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

// IAM policy attachment

resource "aws_iam_role_policy_attachment" "eks_EKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_EKS_CNI_Policy" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_EC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

// Create Node group

resource "aws_eks_node_group" "eks_node_gr" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project_name}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = flatten([var.private_subnets_id])
  
  capacity_type = "ON_DEMAND"
  instance_types = var.instance_type

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    "role" = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_EKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_EKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_EC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name       = "Nurkhat"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "True"
  }
}

// Create EKS cluster Security Group

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.project_name}-eks-cluster-sg"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "Nurkhat"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "True"
  }
}

resource "aws_security_group_rule" "eks_ingress" {
  for_each          = var.eks_inb_ports
  cidr_blocks       = [each.value.cidr]
  description       = "Allow incoming requests from Internet"
  from_port         = each.key
  protocol          = each.value.protocol
  security_group_id = aws_security_group.eks_cluster_sg.id
  to_port           = each.key
  type              = "ingress"
}