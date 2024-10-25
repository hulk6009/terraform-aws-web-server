# Terraform AWS Web Server

This project automates the creation of a web server infrastructure on AWS using Terraform. It provisions a Virtual Private Cloud (VPC), subnets, an internet gateway, route tables, security groups, and an EC2 instance running Apache HTTP Server.

## Features

- **VPC Creation**: Sets up a secure VPC with a defined CIDR block.
- **Subnets**: Creates public and private subnets within the VPC.
- **Internet Gateway**: Attaches an internet gateway to enable external access.
- **Route Tables**: Configures route tables for proper network routing.
- **Security Groups**: Defines security group rules to allow HTTP, HTTPS, and SSH traffic.
- **EC2 Instance**: Launches an EC2 instance with Apache installed for web hosting.
- **Elastic IP**: Associates a public IP address with the EC2 instance for accessibility.

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS account with appropriate permissions to create resources.

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/hulk6009/terraform-aws-web-server.git
   cd terraform-aws-web-server

2. **Configure AWS Credentials**:
     Ensure your AWS credentials are configured. You can set them using the AWS CLI or by creating a credentials file at ~/.aws/credentials.

3. **Initialize Terraform**:
     Run the following command to initialize the project and download necessary providers:
    ```bash
    terraform init
 4. **Plan the Deployment**:
    Create an execution plan to review the resources that will be created:
    ```bash

    terraform plan
   5. Apply the Configuration: Deploy the infrastructure:

     terraform apply
   Confirm the action by typing yes when prompted.

 
## Acknowledgments

Terraform for infrastructure as code.

AWS for cloud services.

