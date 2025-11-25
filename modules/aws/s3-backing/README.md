# S3 Backend Module

## What it does

Creates the AWS infrastructure needed for Terraform remote state storage: an S3 bucket for storing state files and a DynamoDB table for state locking.

## Why it's useful

Terraform state contains sensitive information about your infrastructure and should be stored remotely when working in teams or across multiple machines. S3 provides durable storage for state files, and DynamoDB prevents concurrent modifications through state locking.

This module creates both resources with the correct configuration, saving you from looking up DynamoDB schema requirements for Terraform locking.

## Usage

### Step 1: Create the backend infrastructure

```hcl
module "s3_backing" {
  source = "github.com/alrudolph/tf-utils/modules/aws/s3-backing/module"

  bucket_name = "my-terraform-state-bucket"
  table_name  = "my-terraform-state-lock"
}
```

Apply this first to create the resources.

### Step 2: Configure your backend

After the resources exist, configure your Terraform backend to use them:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/my/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-state-lock"
    encrypt        = true
  }
}
```

Run `terraform init` to migrate your state to S3.

## Variables

- `bucket_name` (required) - Globally unique name for the S3 bucket
- `table_name` (required) - Name for the DynamoDB table

## Important notes

- The DynamoDB table uses `PAY_PER_REQUEST` billing mode to avoid provisioning throughput
- The table is configured with `LockID` as the hash key (required by Terraform)
- This module only creates the infrastructure. You still need to configure the backend block in your Terraform configuration.
- Once you migrate to remote state, you can remove this module from your configuration if desired (the resources will continue to exist)
