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

################################################################
# Crear un API GATEWAY de pruebas
resource "aws_api_gateway_rest_api" "test_api" {
 name = "test-rest-api"
 description = "Testeando un API de AWS en localstack"
}

# resource "aws_api_gateway_resource" "test_resource" {
#   rest_api_id = aws_api_gateway_rest_api.test_api.id
#   parent_id   = aws_api_gateway_rest_api.test_api.root_resource_id
#   path_part   = "hello"
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.test_api.id
#   resource_id   = aws_api_gateway_resource.test_resource.id
#   http_method   = "GET"
#   authorization = "NONE"  
# }

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id = aws_api_gateway_rest_api.test_api.id
#   resource_id = aws_api_gateway_resource.test_resource.id
#   http_method = aws_api_gateway_method.method.http_method
#   type                    = "MOCK"
#   cache_key_parameters = ["method.request.path.param"]
#   cache_namespace      = "foobar"
#   timeout_milliseconds = 29000 
# }

resource "aws_api_gateway_rest_api" "otra_api" {
 name = "otra-rest-api"
 description = "Probando probando..."
}