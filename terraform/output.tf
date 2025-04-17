#This file is useful is you want to create more than one terraform module and need the output from one module as input for another module.


output "raw_bucket_name" {
    description = "The name of the raw data s3 bucket"
    value = aws_s3_bucket.raw_data.id
}
