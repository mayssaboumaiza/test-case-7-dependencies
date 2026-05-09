resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.app.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = { Role = "web-server" }
  depends_on = [aws_db_instance.postgres, aws_elasticache_cluster.redis]
}
resource "aws_lambda_function" "api_handler" {
  function_name = "webapp-api"
  runtime       = "python3.11"
  handler       = "handler.lambda_handler"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "api.zip"
  environment {
    variables = {
      DB_HOST    = aws_db_instance.postgres.address
      CACHE_HOST = aws_elasticache_cluster.redis.cache_nodes[0].address
      S3_BUCKET  = aws_s3_bucket.uploads.bucket
    }
  }
  depends_on = [aws_db_instance.postgres, aws_elasticache_cluster.redis, aws_s3_bucket.uploads]
}
resource "aws_iam_role" "lambda_exec" {
  name = "webapp-lambda-exec"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" } }]
  })
}
