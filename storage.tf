resource "aws_s3_bucket" "uploads" {
  bucket = "webapp-uploads-prod"
  tags   = { Role = "uploads" }
}
resource "aws_sqs_queue" "jobs" {
  name = "webapp-jobs"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
  depends_on = [aws_sqs_queue.dlq]
}
resource "aws_sqs_queue" "dlq" {
  name = "webapp-jobs-dlq"
}
