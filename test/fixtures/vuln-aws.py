import boto3
s3 = boto3.client("s3")
s3.put_object(Bucket="mybucket", Key="file.txt", ACL="public-read")
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
