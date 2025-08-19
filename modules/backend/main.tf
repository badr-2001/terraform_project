resource "aws_s3_bucket" "tfstate" {
  bucket = var.bucket_name
}

#resource "aws_dynamodb_table" "lock" {
 # name         = var.table_name
 # billing_mode = "PAY_PER_REQUEST"
  #hash_key     = "LockID"

  #attribute {
   # name = "LockID"
    #type = "S"
  #}
#}

# Enable versioning
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable default AES-256 encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
