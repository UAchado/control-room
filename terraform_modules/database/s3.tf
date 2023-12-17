resource "aws_s3_bucket" "image_bucket" {
  bucket = "uachado-image-bucket"

  tags = {
    Name        = "Image Bucket"
    Environment = "Prod"
  }
}

resource "aws_iam_user" "boto3_user" {
  name = "boto3_user"
}

resource "aws_iam_access_key" "boto3_user_key" {
  user = aws_iam_user.boto3_user.name
}

resource "aws_iam_user_policy" "boto3_user_policy" {
  name = "boto3_user_policy"
  user = aws_iam_user.boto3_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::uachado-image-bucket",
        "arn:aws:s3:::uachado-image-bucket/*"
      ]
    }
  ]
}
EOF
}
