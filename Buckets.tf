# Random ID to append unique suffix to S3 buckets
resource "random_id" "bucket_suffix_source" {
  byte_length = 4
}

resource "random_id" "bucket_suffix_target" {
  byte_length = 4
}

resource "random_id" "bucket_suffix_code" {
  byte_length = 4
}

# S3 Bucket for Source Data (contains the raw data)
resource "aws_s3_bucket" "source-data-bucket" {
  provider      = aws.eu-central-1
  bucket        = "source-data-bucket-${random_id.bucket_suffix_source.hex}"
  force_destroy = true
}

# S3 Object for Source Data
resource "aws_s3_object" "data-object" {
  provider = aws.eu-central-1
  bucket   = aws_s3_bucket.source-data-bucket.bucket
  key      = "organizations.csv"
  source   = "/home/innotech/ETL-Pipeline-Automation-Glue-S3/organizations.csv"
}

# S3 Bucket for Target Data
resource "aws_s3_bucket" "target-data-bucket" {
  provider      = aws.us-east-1
  bucket        = "target-data-bucket-${random_id.bucket_suffix_target.hex}"
  force_destroy = true
}

# S3 Bucket for Saving Code
resource "aws_s3_bucket" "code-bucket" {
  provider      = aws.us-west-2
  bucket        = "code-bucket-${random_id.bucket_suffix_code.hex}"
  force_destroy = true
}

# S3 Object for Code Data
resource "aws_s3_object" "code-data-object" {
  provider = aws.us-west-2
  bucket   = aws_s3_bucket.code-bucket.bucket
  key      = "script.py"
  source   = "/home/innotech/ETL-Pipeline-Automation-Glue-S3/script.py"
}
