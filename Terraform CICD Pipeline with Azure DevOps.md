# Terraform CI/CD Pipeline with Azure DevOps

This repository contains Terraform code to provision Azure resources and a CI/CD pipeline in **Azure DevOps** to automate deployment.

---

## 🚀 Prerequisites

Before setting up the pipeline, make sure you have:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed locally (`terraform -v`)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed (`az --version`)
- An [Azure DevOps organization](https://dev.azure.com/)
- A Service Connection in Azure DevOps for authentication to Azure
- This repository pushed to GitHub or Azure Repos

---

## 📂 Repository Structure

```
.
├── main.tf          # Terraform configuration
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── README.md        # Project documentation
```

---

## ⚙️ Setup Instructions

### 1. Authenticate with Azure
Login to Azure:
```sh
az login
```

Set the subscription (replace with your Subscription ID):
```sh
az account set --subscription <SUBSCRIPTION_ID>
```

### 2. Initialize Terraform
Run these locally to verify:
```sh
terraform init
terraform validate
terraform plan
```

---

## 📌 Azure DevOps Pipeline Setup

### 1. Create a New Pipeline
- Go to **Azure DevOps** → **Pipelines** → **Create Pipeline**
- Select your repository (GitHub/Azure Repos)

### 2. Configure Pipeline with YAML
Add a file named `.azure-pipelines.yml` to your repo:

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

variables:
  TF_VERSION: '1.7.5'
  AZURE_SUBSCRIPTION: '<Your-Service-Connection-Name>'
  TF_WORKING_DIR: '.'

stages:
  - stage: Terraform
    jobs:
      - job: Terraform
        steps:
          - task: TerraformInstaller@1
            displayName: Install Terraform
            inputs:
              terraformVersion: $(TF_VERSION)

          - task: TerraformTaskV4@4
            displayName: Terraform Init
            inputs:
              provider: 'azurerm'
              command: 'init'
              workingDirectory: $(TF_WORKING_DIR)
              backendServiceArm: $(AZURE_SUBSCRIPTION)

          - task: TerraformTaskV4@4
            displayName: Terraform Plan
            inputs:
              provider: 'azurerm'
              command: 'plan'
              workingDirectory: $(TF_WORKING_DIR)
              environmentServiceNameAzureRM: $(AZURE_SUBSCRIPTION)

          - task: TerraformTaskV4@4
            displayName: Terraform Apply
            inputs:
              provider: 'azurerm'
              command: 'apply'
              workingDirectory: $(TF_WORKING_DIR)
              environmentServiceNameAzureRM: $(AZURE_SUBSCRIPTION)
              commandOptions: '-auto-approve'
```

---

## 🔑 Service Connection Setup

1. Go to **Project Settings → Service connections** in Azure DevOps  
2. Create **Azure Resource Manager → Service Principal (automatic)**  
3. Name it (example: `Azure-Connection`)  
4. Replace `<Your-Service-Connection-Name>` in the YAML with this name  

---

## ✅ Usage

- Push changes to the `main` branch → pipeline will run automatically  
- Check pipeline logs under **Pipelines → Runs**  
- Terraform will deploy resources as per your `.tf` files  

---

## 📖 References

- [Terraform on Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/)
- [Azure DevOps Terraform Task](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/terraform-v4)
- [Azure CLI Docs](https://learn.microsoft.com/en-us/cli/azure/)

---

## 👨‍💻 Author
Created by **Vignesh Suresh Kumar** 🚀  
