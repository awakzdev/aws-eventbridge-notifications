variable "name_prefix" {
  description = "Prefix for the name of the resources."
  type        = string
  default     = "banana"
}

variable "function_name" {
  description = "Name of the Lambda function."
  type        = string
}

variable "filename" {
  description = "Path to the zip file containing the Lambda code."
  type        = string
}

variable "handler" {
  description = "The handler for the Lambda function."
  type        = string
}

variable "runtime" {
  description = "Runtime for the Lambda function."
  type        = string
}

variable "enable_destination" {
  description = "If true, configure the Lambda asynchronous invocation destination."
  type        = bool
  default     = true
}

variable "create_cloudwatch_group" {
  description = "If true, create a CloudWatch Log Group for the Lambda function."
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "A map of environment variables for the Lambda function."
  type        = map(string)
  default     = {}
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function (in seconds)"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memory size for the Lambda function (in MB)"
  type        = number
  default     = 128
}
