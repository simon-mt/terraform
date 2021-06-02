variable "bucket_name" {
  description = "The name of the S3 bucket used to store state"
  type        = string
  default     = "terraform-up-and-running-simon02062021"
}

variable "table_name" {
  description = "The name of the DynamoDB table used for the state locks"
  type        = string
  default     = "terraform-up-and-running-locks"
}