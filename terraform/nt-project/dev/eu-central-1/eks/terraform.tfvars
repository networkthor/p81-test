project_name       = "nt-project-dev"
region             = "eu-central-1"
instance_type      = ["t3.small"]
desired_size       = "1"
max_size           = "1"
min_size           = "1"
eks_inb_ports      = {
  8080 = {
    protocol = "TCP"
    cidr     = "0.0.0.0/0"
  }
}