resource "aws_iam_policy" "lambda_s3" {
  name = "webapp-lambda-s3-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:PutObject"]
      Resource = "${aws_s3_bucket.uploads.arn}/*"
    }]
  })
  depends_on = [aws_s3_bucket.uploads]
}
resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_s3.arn
  depends_on = [aws_iam_role.lambda_exec, aws_iam_policy.lambda_s3]
}
