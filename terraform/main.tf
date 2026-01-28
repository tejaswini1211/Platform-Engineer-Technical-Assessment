provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-03ea746da1a2e36e7" // Amazon Linux
  instance_type = "t3.micro"

  tags = {
    Name = "pacerpro-web"
  }
}

# SNS Topic
resource "aws_sns_topic" "alerts" {
  name = "pacerpro-alerts"
}

# Lambda Function
resource "aws_lambda_function" "restart_ec2" {
  function_name = "restart-ec2-on-alert"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  filename      = "../lambda_function/lambda.zip"

  environment {
    variables = {
      INSTANCE_ID   = aws_instance.web.id
      SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
    }
  }

  depends_on = [aws_iam_role_policy.lambda_policy]
}
