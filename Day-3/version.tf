resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.newB.id
  versioning_configuration {
    status = "Enabled"
  }
}