# GitHub Actions

GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline.

### Structure of repo:
- app-ci.yml     -  Continuous integration file for application
- app-cd.yml     -  Continuous deployment file for application

### This CICD do the following actions:
- build, push and deploy application to test/stage env for branches
- build, push and deploy application to prod env for main

## Steps for branch:

1.	Developer add new features to app code and push to GitHub branch
2.	Start build, push and deploy to test/stage proccesses for his branch.
3.	On branches branch name used as container tag on registry
4.  Test app

## Steps for main:

1.	Developer create PR for merge from his branch to main
2.	Start build, push and deploy to prod proccesses for main.
3.	On main branch git tag used as container tag on registry
4.  Test app

⚠️ **IMPORTANT** 

```
CI and CD works only after deploying infra on AWS and configure EKS for deploying application
```