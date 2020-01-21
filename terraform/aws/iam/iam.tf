# Managed policies
data "aws_iam_policy" "EC2FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

data "aws_iam_policy" "APIGatewayFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}

data "aws_iam_policy" "S3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


provider "aws" {
  region                      = "eu-west-1"
  access_key                  = "var.aws_access_key"
  secret_key                  = "var.aws_secret_key"
  
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_force_path_style         = true
  
  endpoints {
    apigateway     = "http://localhost:4567"
    cloudformation = "http://localhost:4581"
    cloudwatch     = "http://localhost:4582"
    dynamodb       = "http://localhost:4569"
    es             = "http://localhost:4578"
    firehose       = "http://localhost:4573"
    iam            = "http://localhost:4593"
    kinesis        = "http://localhost:4568"
    lambda         = "http://localhost:4574"
    route53        = "http://localhost:4580"
    redshift       = "http://localhost:4577"
    s3             = "http://localhost:4572"
    secretsmanager = "http://localhost:4584"
    ses            = "http://localhost:4579"
    sns            = "http://localhost:4575"
    sqs            = "http://localhost:4576"
    ssm            = "http://localhost:4583"
    stepfunctions  = "http://localhost:4585"
    sts            = "http://localhost:4592"
  }
}
resource "aws_iam_group" "k8s_developers" {
  name = "k8s-developers"
}

resource "aws_iam_group" "s3_users" {
  name = "s3-users"
}


resource "aws_iam_group_policy_attachment" "k8s-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  group = "k8s-developers"
}

resource "aws_iam_group_policy_attachment" "s3-attach" {
  policy_arn =  data.aws_iam_policy.S3FullAccess.arn
  group = aws_iam_group.s3_users.name
}

resource "aws_iam_user" "k8sadmin" {
  name = "k8sadmin"
}

resource "aws_iam_group_membership" "k8s-team" {
  name = "k8s-team"

  users = [aws_iam_user.k8sadmin.name]

  group = aws_iam_group.k8s_developers.name

}

variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = "list"
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess", 
    "arn:aws:iam::aws:policy/IAMFullAccess", 
    "arn:aws:iam::aws:policy/AmazonS3FullAccess", 
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess", 
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"]

}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = "${var.iam_role_name}"
  count      = "${length(var.iam_policy_arn)}"
  policy_arn = "${var.iam_policy_arn[count.index]}"
}

resource "aws_iam_role" "k8s_role" {
  name = "k8s_role"
  assume_role_policy = <<EOF
{
  "Version": "2020-01-16",
  "Statement": [
    {
      "Action": "sts:AssumeRole",      
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF