provider "aws" {
    region = "eu-west-2"
}

# Creates an S3 bucket for the terraform state file.
resource "aws_s3_bucket" "terraform-state" {
    bucket = "terraform-up-and-running-state-simonb20210528"

    # Prevent accidental deletion of this S3 bucket.
    lifecycle {
        prevent_destroy = true
    }

    # Enable versioning so we can see the full revision history of our state files.
    versioning {
        enabled = true
    }

    # Enable server-side encryption by default.
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

# Create a DynamoDB table for the for storing the state lock file.
resource "aws_dynamodb_table" "terraform_locks" {
    name         = "terraform-up-and-running-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

# Configure the terraform backend to use the resources above for state management.
terraform {
    backend "s3" {
        bucket = "terraform-up-and-running-state-simonb20210528"
        key    = "global/s3/terraform.tfstate"
        region = "eu-west-2"

        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true
    }
}