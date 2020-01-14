## Variables
variable "dockercompose_dir" {
  type = string
  # Comentar para que pida el directorio en el que está el docker-compose de localstack
  default = "/home/rosario.priego/sw/localstack/"
}

variable "localstack_hostname" {
  type    = string
  default = ""
}

variable aws_access_key {
  type = string
  default = "tree"
}

variable aws_secret_key {
  type = string
  default = "tree"
}

## Env variables for docker
variable aws_region {
    type  = string
    default = "us-west-2"
}

#//TODO: hacer que sea una lista de servicios
variable localstack_services {
    type = string
    # serverles -> serverless: run services often used for Serverless apps (iam, lambda, dynamodb, apigateway, s3, sns)
    default = "SERVICES=iam,lambda,dynamodb,apigateway,s3,sns,kinesis"
}

variable lambda_executor {
  type = string
  default = "LAMBDA_EXECUTOR=docker"
}

variable lambda_remote_docker {
  type = string
  default = "LAMBDA_REMOTE_DOCKER=false"
}