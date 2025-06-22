# Lab1 - Azure Terraform Setup

This directory contains Terraform code for provisioning foundational Azure resources for the homelab project.

## Overview

Lab1 provisions the following Azure resources:
- **Resource Group**: Isolated container for resources.
- **Random String**: Used as a suffix for unique resource naming.
- **Storage Account**: Stores Terraform state files securely.
- **Storage Container**: Holds the `tfstate` blob for remote state management.

## File Structure

- `main.tf`: Main Terraform configuration for resource provisioning.
- `variables.tf`: Input variables for customization.
- `outputs.tf`: Outputs from the deployed resources.
- `terraform.tfvars`: Variable values for this environment.
- `environment/`: Contains environment-specific variable files (e.g., `dev.tfvars`, `prod.tfvars`).

## Usage

1. **Initialize Terraform:**
   ```sh
   terraform init
   ```

2. **Select or create a workspace (optional):**
   ```sh
   terraform workspace new dev
   ```

3. **Plan the deployment:**
   ```sh
   terraform plan -var-file="environment/dev.tfvars"
   ```

4. **Apply the configuration:**
   ```sh
   terraform apply -var-file="environment/dev.tfvars"
   ```

## Remote State

The storage account and container created here are intended for storing the Terraform remote state file (`tfstate`). This enables safe collaboration and state locking.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure CLI authenticated (`az login`)
- Sufficient permissions to create resources in the target Azure subscription

## Clean Up

To destroy all resources created by this lab:
```sh
terraform destroy -var-file="environment/dev.tfvars"
```

---

For more details, see the individual Terraform files in this directory.
