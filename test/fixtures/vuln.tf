resource "aws_s3_bucket" "data" {
  bucket = "public-data"
  acl = "public-read"
}
resource "aws_security_group" "web" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "main" {
  storage_encrypted = false
  password = "supersecret123456"
}
resource "aws_cloudfront_distribution" "s" {
  default_cache_behavior {
    viewer_protocol_policy = "allow-all"
  }
  enforce_https = false
}
