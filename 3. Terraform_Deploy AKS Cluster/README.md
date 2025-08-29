# Terraform AKS Deployment

## Overview
This configuration deploys an Azure Kubernetes Service (AKS) cluster with a system-assigned identity, kubenet networking, and an SSH keypair generated via AzAPI. Randomized names ensure global uniqueness for the resource group, cluster name, DNS prefix, and SSH key resource.

## What gets created
- Resource Group with randomized name in the selected region.
- AKS cluster with default node pool (Standard_D2_v2) and configurable node_count.
- SSH public key resource and keypair generation via AzAPI; public key injected into AKS Linux profile.
- Network profile using kubenet and Standard Load Balancer.

## Repository layout
- **providers.tf**: Required providers and azurerm provider config.
- **variables.tf**: Inputs for location, RG name prefix, node_count, optional msi_id, and admin username.
- **main.tf**: Resource group, AKS cluster, randomized names, linux_profile, network_profile.
- **ssh.tf**: sshPublicKeys resource plus generateKeyPair action; exposes publicKey output.
- **outputs.tf**: Resource names and kubeconfig details marked sensitive.

## Prerequisites
- Terraform >= 1.0 installed.
- Azure CLI logged in to a subscription with permissions for RG, AKS, and Compute sshPublicKeys.
- Providers: azurerm ~> 3.0, azapi ~> 1.5, random ~> 3.0, time 0.9.1 (already pinned).

## Quick start
1. **Initialize**
   ```sh
   terraform init
   ```

2. **Configure (optional)**
   - Update values via `terraform.tfvars` or CLI flags for location, node_count, username.

3. **Plan and apply**
   ```sh
   terraform plan
   terraform apply
   ```

4. **Fetch kubeconfig**
   ```sh
   terraform output -raw kube_config > kubeconfig
   export KUBECONFIG="$(pwd)/kubeconfig"
   ```

5. **Test access**
   ```sh
   kubectl get nodes
   ```

## Inputs
- **resource_group_location**: Region for all resources. Default: "eastus".
- **resource_group_name_prefix**: Prefix for randomized RG name. Default: "rg".
- **node_count**: Initial node count for default pool. Default: 3.
- **msi_id**: Optional Managed Identity ID if authenticating via MI. Default: null.
- **username**: Admin username for AKS Linux profile. Default: "azureadmin".

## Outputs
- **resource_group_name**, **kubernetes_cluster_name** for discovery.
- **kube_config (raw)** and kube_config fields: client_certificate, client_key, cluster_ca_certificate, username, password, and host (all sensitive).

## Security notes
- Sensitive outputs are flagged—do not commit terraform output to source control; handle kubeconfig and private key data securely.
- Review node_count and access controls; add role assignments and network policies as required for production.

## Customization tips
- Change **vm_size** under default_node_pool for workload needs.
- Switch **network_profile** to Azure CNI if pod IP requirements demand VNet-level addressing.
- Replace **random_pet** naming if deterministic names are required; ensure global uniqueness for AKS DNS prefix.

## Cleanup
```sh
terraform destroy
```

## Example terraform.tfvars
```hcl
resource_group_location = "eastus"
resource_group_name_prefix = "rg"
node_count = 3
username = "azureadmin"
```
