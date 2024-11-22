resource "aws_glue_job" "org_report_job" {
  provider = aws.us-west-2
  name     = "org-report-job"
  role_arn = aws_iam_role.glue_service_role.arn  # Use the previously created IAM role ARN

  command {
    name            = "glueetl"
    script_location = "s3://code-bucket-610c0160/script.py" # Path to the ETL script in S3
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"                        = "s3://${aws_s3_bucket.source-data-bucket.bucket}/tmp/"
    "--job-language"                   = "python"
    "--enable-metrics"                 = ""
    "--enable-continuous-cloudwatch-log" = "true"
  }

  max_retries  = 1
  glue_version = "3.0"
  max_capacity = 2  # Enable autoscaling
}
