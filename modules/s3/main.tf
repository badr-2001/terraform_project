resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true   # optional, so you don’t get "bucket not empty" error in dev
}

# Allow ALB to write logs
data "aws_elb_service_account" "this" {}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_elb_service_account.this.arn
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}
