variable "aws_region" {
    description = "AWS region to deploy resources"
    default = "us-east-1"
}

variable "project_name" {
    description = "The name of the project"
    default = "dml-customer-analysis"    
}

variable "use_existing_bucket" {
    description = "set to true to use an exisiting s3 bucket instead of creating a new one"
    type = bool
    default = false
}

variable "existing_bucket_name" {
    description = "The name of the S3 bucket resource"
    type = string
    default = "dml-customer-analysis-raw-data"
}