module "lambda_function" {
  source                  = "./modules/lambda"
  function_name           = "${var.name_prefix}-CloudTrailLambda"
  filename                = "code.zip"
  handler                 = "lambda_function.lambda_handler"
  runtime                 = "python3.9"
  enable_destination      = true # Triggers SNS as a destination (defaults to true)
  create_cloudwatch_group = true # Creates a CloudWatch Log Group (defaults to true)

  environment_variables = {
    SNS_TOPIC_ARN = module.lambda_function.sns_topic_arn
  }
}

module "eventbridge_rule" {
  source    = "./modules/eventbridge"
  rule_name = "${var.name_prefix}-LambdaTriggerRule"

  event_pattern = jsonencode({
    "detail-type" : ["AWS API Call via CloudTrail"],
    "source" : ["aws.iam", "aws.s3", "aws.ec2"],
    "detail" : {
      "eventName" : ["CreateUser", "CreateAccessKey", "DeleteBucketPolicy", "PutBucketPolicy", "AuthorizeSecurityGroupIngress"]
    }
  })

  lambda_function_arn = module.lambda_function.lambda_arn
}