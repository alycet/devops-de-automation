data "aws_s3_bucket" "existing" {
    count = var.use_existing_bucket ? 1 : 0 
    bucket = var.existing_bucket_name
}

resource "aws_s3_bucket" "raw_data" {
    bucket = "${var.project_name}-raw-data"
    force_destroy = true

    tags = {
        Name = "${var.project_name}-raw-data"
        Environment = "dev"
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "raw_data" {
    bucket = aws_s3_bucket.raw_data.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }

}

resource "aws_s3_object" "customer_data" {
    bucket = aws_s3_bucket.raw_data.id
    key = "data/customer_data.csv"
    source = "./../data/customer_data.csv"
    content_type = "text/csv"
}

#Glue Role

resource "aws_iam_role" "glue_role" {
    name = "AWSGlueServiceRole-dml-customer-analysis"
    force_detach_policies = true

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "glue.amazonaws.com"
            }
        }]

    })

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_iam_role_policy_attachment" "glue_service_role" {
    role = aws_iam_role.glue_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "glue_s3_access" {
    role = aws_iam_role.glue_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#Glue Database

resource "aws_glue_catalog_database" "main" {
    name = "customer-analysis-catalog"
    
    lifecycle {
        create_before_destroy = true
    }
}

#Glue Crawler

resource "aws_glue_crawler" "main" {
    name = "customer_analysis_crawler" 
    database_name = aws_glue_catalog_database.main.name
    role = aws_iam_role.glue_role.name
    schedule = "cron(0 1 * * ? *)"

    s3_target {
        path = "s3://${aws_s3_bucket.raw_data.id}/data/"
    }

    schema_change_policy {
        delete_behavior = "LOG"
        update_behavior = "UPDATE_IN_DATABASE"
    }

    recrawl_policy {
        recrawl_behavior = "CRAWL_EVERYTHING"
    }

    lake_formation_configuration {
        use_lake_formation_credentials = false
    }

    lifecycle {
        create_before_destroy = true
    }

    depends_on = [
        aws_s3_bucket.raw_data, #s3 bucket must be created
        aws_s3_object.customer_data, #data directory within s3 bucket must be created
        aws_iam_role_policy_attachment.glue_service_role #glue service role must be attached to policy
    ]

}