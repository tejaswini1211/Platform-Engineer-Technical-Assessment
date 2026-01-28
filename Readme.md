PacerPro – Platform Engineer Coding Exercise
Overview

This project implements an automated monitoring and remediation workflow for a web application experiencing intermittent latency issues. Slow API responses are detected using Sumo Logic, triggering an AWS Lambda function that restarts an EC2 instance and sends an SNS notification. All infrastructure is provisioned using Terraform.

Architecture
Sumo Logic Alert → AWS Lambda → EC2 Reboot → SNS Notification

Repository Structure
├── sumo_logic_query.txt
├── lambda_function/
│   ├── lambda_function.py
│   └── lambda.zip
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── iam.tf
│   └── outputs.tf
└── README.md

Assumptions

Logs are JSON formatted and include path and response_time_ms

/api/data responses > 3s indicate performance degradation

EC2 reboot is sufficient for transient issues

Single EC2 instance for simplicity

Part 1: Sumo Logic

Query: Identifies /api/data requests exceeding 3 seconds and aggregates over 10 minutes.
Alert: Triggers when more than 5 slow requests occur in a 10-minute window.

Part 2: AWS Lambda

Triggered by Sumo Logic alert

Reboots EC2 instance

Logs actions to CloudWatch

Sends notification via SNS

Deployed using a manually created ZIP package

Part 3: Terraform (IaC)

Terraform provisions:

EC2 instance

Lambda function

SNS topic

IAM role with least-privilege permissions

AWS Credentials (Demo Only)

Static credentials are passed via Terraform variables for demo purposes only.

⚠️ In production, AWS CLI profiles or IAM roles should be used. No credentials are committed to source control.

Deployment
terraform init
terraform apply


Cleanup:

terraform destroy

Recordings

Screen and audio recordings demonstrate:

Sumo Logic query and alert setup

Lambda deployment and testing

Terraform provisioning and verification

Improvements

Auto Scaling instead of EC2 reboot

Percentile-based latency alerts

Multi-environment Terraform setups