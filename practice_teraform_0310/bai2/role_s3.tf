resource "aws_iam_role" "s3_role" {
  name = "S3_Role"

  assume_role_policy = file("assume_role_ec2.json")
  inline_policy {
    name = "S3PutObjectAccess"
    policy = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "s3:PutObject",
            ],
            "Resource" : "arn:aws:s3:::${var.bucket}"
          }
        ]
      }
    )
  }
}
