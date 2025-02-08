resource "aws_sns_topic" "this" {
  name = "${var.name_prefix}-SNSTopic"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.name_prefix}_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size
  role             = aws_iam_role.lambda_exec.arn

  environment {
    variables = var.environment_variables
  }
}

resource "aws_iam_role_policy" "sns_publish" {
  count = var.enable_destination ? 1 : 0
  name  = "${var.name_prefix}_sns_publish"
  role  = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sns:Publish",
        Resource = aws_sns_topic.this.arn
      }
    ]
  })
}

resource "aws_lambda_function_event_invoke_config" "lambda_dest" {
  count         = var.enable_destination ? 1 : 0
  function_name = aws_lambda_function.this.arn
  qualifier     = "$LATEST"

  destination_config {
    on_success {
      destination = aws_sns_topic.this.arn
    }
    on_failure {
      destination = aws_sns_topic.this.arn
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_log" {
  count             = var.create_cloudwatch_group ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
}