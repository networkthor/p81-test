# Terraform

CloudFormation is an infrastructure automation platform for AWS that deploys AWS resources in a repeatable, testable and auditable manner. 

### This Terraform manifests deploy the following resources:
- Virtual Private Cloud
- Subnet/CIDR blocks
- Routing/NAT
- Security Groups
- EKS cluster
- Container Registry

### Structure of repo:
- modules      -  collection of custom terraform modules. Using this module you can deploy VPC, EKS, ECR
- nt-project   -  random name of your test project. In this project we have dev/stage directories for relevant environments.
- ecr/eks/vpc  -  resource directories in every env, it helps to store separated terraform state files.
- tfvars       -  default values is stored in tfvars files

## Steps:

1.	Clone this repo to your local machine
2.	Install Terraform for your local machine. Use this repository https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
3.	Go to the nt-project/dev directory and choose needed resource
4.  Run terraform commands (commands section)


⚠️ **IMPORTANT** 

```
This terraform manifest deploy only VPC, ECR, EKS cluster. To deploy ingress and application resources, check helm-charts directory
```


## Commands
Validate manifest: 

```
terraform validate

```
Check plan:

```
terraform plan

```
Apply resources:

```
terraform apply

```

### Check resources:

```
Check EKS cluster on AWS Console

```