resource "aws_s3_bucket" "data" {
  acl = "public-read"
  versioning { enabled = false }
  logging { enabled = false }
}
resource "aws_security_group" "web" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "db" {
  publicly_accessible = true
  backup_retention_period = 0
  deletion_protection = false
}
resource "aws_iam_policy" "policy" {
  policy = {
    Statement = {
      Action = "*"
      Resource = "*"
    }
  }
}
password = "hardcodedpassword"
ssl = false
encryption = false
