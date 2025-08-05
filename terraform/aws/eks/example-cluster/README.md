# Example EKS Cluster Creation with Terraform

This project demonstrates how to create an Amazon EKS (Elastic Kubernetes Service) cluster using Terraform. The configuration provisions the following AWS resources:

## Resources Created

- **1 VPC**: A dedicated Virtual Private Cloud for the cluster.
- **2 Public Subnets**: Subnets for public access, suitable for worker nodes and load balancers.
- **1 Internet Gateway**: Enables internet access for resources in the public subnets.
- **1 Route Table**: Manages routing for the public subnets.
- **1 Route Table Rule to the Internet Gateway**: Allows outbound traffic to the internet.
- **2 Route Table Associations**: Associates the route table with both public subnets.
- **EKS Cluster**: Managed Kubernetes cluster with node groups.

## Usage

1. **Initialize Terraform**
   ```powershell
   terraform init
   ```
2. **Review and Apply the Plan**
   ```powershell
   terraform plan
   terraform apply
   ```
3. **Access the Cluster**
   - After deployment, configure your `kubectl` using the generated kubeconfig.

## Files
- `eks.tf`: Main Terraform configuration for EKS and networking resources.
- `main.tf`, `variables.tf`, etc.: Additional configuration files as needed.

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed

## Notes
- The cluster is created with public endpoint access and admin permissions for the creator.
- Node group uses `t3.medium` instances by default.

---

Feel free to customize the configuration for your environment or requirements.
