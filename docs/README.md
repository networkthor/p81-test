## Project Documents

This project is used to deploy Python webserver application on AWS EKS cluster. Whole AWS environment is deployed with Terraform manifests. And Application is deployed with Helm.

### Structure of repo:
- app-code                  -  Application source code and Dockerfile
- terraform                 -  manifests to deploy AWS env
- helm-charts               -  helm templates which used to generate custom application resources
- .github                   -  CICD files


#### AWS insfrastructure topology:
![AWS Infra](./AWS%20Infra%20Topolgy.jpg)

#### Webserver Cloud Topology:
![App](./AWS%20Application%20Topology.jpg)


## Steps:

1.	Clone this repo to your local machine
2.	Deploy AWS env with terraform (check terraform direcotory Readme.md)
3.	Build and push application container to AWS ECR (check app-code directory Readme.md)
4.  Deploy ingress-controller and application to EKS with Helm (check helm-charts directory Readme.md)
5.  Configure cicd (check .github/workflows directory Readme.md)