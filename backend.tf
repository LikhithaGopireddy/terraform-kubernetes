# resource "aws_s3_bucket" "bucket1" {
#   bucket = "terraform-backend-bucket-lb9"
#
#   tags = {
#     Name        = "My bucket"
#
#   }
#
# }
# resource "aws_s3_bucket_versioning" "versioning_example" {
#   bucket = aws_s3_bucket.bucket1.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

