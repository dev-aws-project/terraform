resource "aws_s3_bucket" "remote_backend" {
  bucket = var.s3_name

  tags = {
    Name = "Terraform Remote Backend"
  }
}

# resource "aws_s3_bucket_acl" "remote_backend_acl" {
#   bucket = aws_s3_bucket.remote_backend.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.remote_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

