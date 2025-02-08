# AWS Event-Driven Alerting Solution

This Terraform snippet deploys an event-driven alerting mechanism on AWS.

## Components

- **Lambda Function:**  
  A Python Lambda function (packaged as `code.zip` in the Terraform folder) that processes incoming CloudTrail events. The function uses an environment variable `SNS_TOPIC_ARN` to know where to send notifications.

- **SNS Topic:**  
 The Lambda function publishes its asynchronous results to this SNS topic.

- **EventBridge Rule:**  
  An EventBridge rule with a specific event pattern monitors CloudTrail events for:
  - IAM user creation (`CreateUser`)
  - IAM access key creation (`CreateAccessKey`)
  - S3 bucket policy changes (`DeleteBucketPolicy`, `PutBucketPolicy`)
  - EC2 security group ingress changes (`AuthorizeSecurityGroupIngress`)

  When an event matching the pattern occurs, the Lambda function is triggered.

- **IAM Roles and Policies:**  
  A dedicated IAM role is created for the Lambda function, including basic execution policies and an inline policy that grants SNS publish permissions.

- **CloudWatch Log Group:**  
  A CloudWatch Log Group is created for the Lambda function logs.

- **Provider Configuration:**  
  The AWS provider is set to `us-east-1` because IAM events are logged globally in that region.

## Directory Structure
```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── lambda/
│   │   ├── main.tf
│   │   └── variables.tf
│   │   └── outputs.tf
│   └── eventbridge/
│       ├── main.tf
│       └── variables.tf
└── code.zip
```

## Deployment Instructions

1. **Configure AWS Credentials:**  
   Set your AWS credentials in your environment. For example, in a Unix shell:
   ```bash
   export AWS_ACCESS_KEY_ID=your_access_key
   export AWS_SECRET_ACCESS_KEY=your_secret_key
   export AWS_DEFAULT_REGION=us-east-1

2. **Initialize Terraform:**  
   ```bash
   terraform init
   ```

3. **Plan the Deployment:**  
   ```bash
   terraform plan
   ```

4. **Apply the Configuration:**  
   ```bash
   terraform apply
   ```

## Testing the Solution

1. **Enable Discovery for the Default EventBridge Bus:**

   By default, CloudTrail sends events to the default event bus. To ensure schema discovery is initiated on the default bus, follow these steps:

     - Log in to the [AWS EventBridge Console](https://console.aws.amazon.com/events/home).
     - Under Resources click on **Event buses**.
     - Select the **Default Event Bus**.
     - Click **Start discovery** to initiate schema discovery.

2. **Create an SNS Subscription:**

   To receive notifications, subscribe an endpoint (such as an email address or an SMS number) to the SNS topic that was created by the Terraform deployment.
   
   - Open the [SNS Console](https://console.aws.amazon.com/sns/v3/home).
   - Locate the SNS topic created by Terraform. **(banana-SNSTopic in us-east-1 by default)**
   - Click **Create subscription**.
   - For **Protocol**, choose either `Email` or `SMS`.
   - For **Endpoint**, enter your email address or phone number.
   - Click **Create subscription**.
   - Verify your subscription endpoint.
   
3. **Trigger a CloudTrail Event:**

   Perform one or more of the following actions to generate CloudTrail events that match your EventBridge rule:
   
   - **IAM Events:**
     - Create a new IAM user.
     - Create new access keys for an existing IAM user.
   - **S3 Events:**
     - Modify the bucket policy on an S3 bucket (for example, delete a bucket policy).
   - **EC2 Events:**
     - Change an EC2 security group ingress rule (for example, add or modify an ingress rule that allows traffic).

   These actions will generate CloudTrail events that trigger your EventBridge rule. When a matching event occurs, your Lambda function is invoked and sends a notification via SNS to your subscription endpoint.

---

