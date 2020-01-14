# Localstack like AWS provider
provider "aws" {
  # profile                     = "default"
  region                      = var.aws_region
  access_key                  = "var.aws_access_key"
  secret_key                  = "var.aws_secret_key"
  # version                     = "~> 2.0"
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

## Levantar EN LOCAL el docker compose de localstack con las variables de environment necesarias
resource "null_resource" "localstack_up" {

  provisioner "local-exec" {
    command = "env $SERVICES $DEFAULT_REGION $LAMBDA_EXECUTOR $LAMBDA_REMOTE_DOCKER docker-compose up -d "

    environment = {
      SERVICES       = var.localstack_services
      DEFAULT_REGION = "DEFAULT_REGION=var.aws_region"
      LAMBDA_EXECUTOR = var.lambda_executor
      LAMBDA_REMOTE_DOCKER = var.lambda_remote_docker
    }

    working_dir = var.dockercompose_dir

  }

  provisioner "local-exec" {
    when    = destroy
    command = "docker rm -f $(docker ps -aq)"
  }
}

# ################################################################
# # Crear un bucket de s3 
# resource "aws_s3_bucket" "rowsbucket" {
#   bucket = "rows-bucket"
#   acl    = "public-read"
# }








