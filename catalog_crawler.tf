# Define the AWS Provider
provider "aws" {
  region = "us-west-2"  # Specify the AWS region
}

# Create Glue Data Catalog Database
resource "aws_glue_catalog_database" "org_report_database" {
  provider    = aws.us-west-2
  name        = "org-report"
  location_uri = "s3://${aws_s3_bucket.source-data-bucket.bucket}/"  # Use the correct attribute for the S3 bucket name
}

# Create Glue Crawler
resource "aws_glue_crawler" "org_report_crawler" {
  provider      = aws.us-west-2
  name          = "org-report-crawler"
  database_name = aws_glue_catalog_database.org_report_database.name
  role          = aws_iam_role.glue_service_role.arn  # Use ARN instead of name for the role

  s3_target {
    path = "s3://${aws_s3_bucket.source-data-bucket.bucket}/"  # Use the correct attribute for the S3 bucket name
  }

  schema_change_policy {
    delete_behavior = "LOG"
  }

  configuration = <<EOF
{
  "Version": 1.0,
  "Grouping": {
    "TableGroupingPolicy": "CombineCompatibleSchemas"
  }
}
EOF
}

# Create Glue Trigger
resource "aws_glue_trigger" "org_report_trigger" {
  provider = aws.us-west-2
  name     = "org-report-trigger"
  type     = "ON_DEMAND"
  
  actions {
    crawler_name = aws_glue_crawler.org_report_crawler.name
  }
}
