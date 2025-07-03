# AWS Terraform Concepts Project

This project demonstrates key Terraform concepts by provisioning a scalable web application infrastructure on AWS. It includes resources for networking, security, compute, and load balancing, and uses user data to deploy a static website theme.

## Features

- **VPC & Subnets**: Uses the default AWS VPC and its subnets.
- **Security Groups**: Separate security groups for the Application Load Balancer (ALB) and EC2 instances.
- **Launch Template**: Configures EC2 instances with Apache, and deploys the Illdy HTML theme via user data.
- **Auto Scaling Group**: Ensures high availability and scalability for the application.
- **Application Load Balancer**: Distributes incoming traffic across EC2 instances.
- **Outputs**: Exposes the ALB DNS name for easy access.

## File Structure

- `main.tf` — Main Terraform configuration for AWS resources and user data script.
- `output.tf` — Outputs the ALB DNS name after deployment. (must be present for deployment).

## Usage

1. **Initialize Terraform**
   ```sh
   terraform init
   ```

2. **Plan the Deployment**
   ```sh
   terraform plan
   ```

3. **Apply the Configuration**
   ```sh
   terraform apply
   ```

4. **Access the Application**
   - After deployment, find the ALB DNS name in the Terraform output or in the AWS console.

## Requirements

- AWS account and credentials configured (e.g., via `aws configure`)
- [Terraform](https://www.terraform.io/downloads.html) installed

## Clean Up

To destroy all resources created by this project:
```sh
terraform destroy
```

---

This project is for learning and demonstration purposes. Adjust variables and resource settings as needed for use.
