variable "rule_name" {
  description = "Name for the EventBridge rule."
  type        = string
}

variable "event_pattern" {
  description = "The event pattern JSON (as a string) for the rule."
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function that will be triggered."
  type        = string
}
