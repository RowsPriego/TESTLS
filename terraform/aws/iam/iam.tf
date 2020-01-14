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
  region                      = "us-west-2"
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

