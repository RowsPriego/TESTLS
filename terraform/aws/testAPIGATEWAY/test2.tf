# Provide AWS Credentials
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

# Create S3 Full Access Policy
resource "aws_iam_policy" "s3_policy" {
  name        = "s3-policy"
  description = "Policy for allowing all S3 Actions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

# Create API Gateway Role
resource "aws_iam_role" "s3_api_gateyway_role" {
  name = "s3-api-gateyway-role"

  # Create Trust Policy for API Gateway
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
} 
  EOF
}

# Attach S3 Access Policy to the API Gateway Role
resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = "${aws_iam_role.s3_api_gateyway_role.name}"
  policy_arn = "${aws_iam_policy.s3_policy.arn}"
}

resource "aws_api_gateway_rest_api" "MyS3" {
  name        = "MyS3"
  description = "API for S3 Integration"
}

resource "aws_api_gateway_resource" "Folder" {
  rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
  parent_id   = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
  path_part   = "{folder}"
}

resource "aws_api_gateway_resource" "Item" {
  rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
  parent_id   = "${aws_api_gateway_resource.Folder.id}"
  path_part   = "{item}"
}

resource "aws_api_gateway_method" "GetBuckets" {
  rest_api_id   = "${aws_api_gateway_rest_api.MyS3.id}"
  resource_id   = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "S3Integration" {
  rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
  resource_id = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
  http_method = "${aws_api_gateway_method.GetBuckets.http_method}"

  # Included because of this issue: https://github.com/hashicorp/terraform/issues/10501
  integration_http_method = "GET"

  type = "AWS"

  # See uri description: https://docs.aws.amazon.com/apigateway/api-reference/resource/integration/
  uri         = "arn:aws:apigateway:us-west-2:s3:path//"
  credentials = "${aws_iam_role.s3_api_gateyway_role.arn}"
}

# resource "aws_api_gateway_method_response" "200" {
#   rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
#   resource_id = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
#   http_method = "${aws_api_gateway_method.GetBuckets.http_method}"
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Timestamp"      = true
#     "method.response.header.Content-Length" = true
#     "method.response.header.Content-Type"   = true
#   }

#   response_models = {
#     "application/json" = "Empty"
#   }
# }

# resource "aws_api_gateway_method_response" "400" {
#   depends_on = ["aws_api_gateway_integration.S3Integration"]

#   rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
#   resource_id = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
#   http_method = "${aws_api_gateway_method.GetBuckets.http_method}"
#   status_code = "400"
# }

# resource "aws_api_gateway_method_response" "500" {
#   depends_on = ["aws_api_gateway_integration.S3Integration"]

#   rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
#   resource_id = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
#   http_method = "${aws_api_gateway_method.GetBuckets.http_method}"
#   status_code = "500"
# }

# resource "aws_api_gateway_integration_response" "200IntegrationResponse" {
#   depends_on = ["aws_api_gateway_integration.S3Integration"]

#   rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
#   resource_id = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
#   http_method = "${aws_api_gateway_method.GetBuckets.http_method}"
#   status_code = "${aws_api_gateway_method_response.200.status_code}"

#   response_parameters = {
#     "method.response.header.Timestamp"      = "integration.response.header.Date"
#     "method.response.header.Content-Length" = "integration.response.header.Content-Length"
#     "method.response.header.Content-Type"   = "integration.response.header.Content-Type"
#   }
# }

# resource "aws_api_gateway_integration_response" "400IntegrationResponse" {
#   depends_on = ["aws_api_gateway_integration.S3Integration"]

#   rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
#   resource_id = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
#   http_method = "${aws_api_gateway_method.GetBuckets.http_method}"
#   status_code = "${aws_api_gateway_method_response.400.status_code}"

#   selection_pattern = "4\\d{2}"
# }

# resource "aws_api_gateway_integration_response" "500IntegrationResponse" {
#   depends_on = ["aws_api_gateway_integration.S3Integration"]

#   rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
#   resource_id = "${aws_api_gateway_rest_api.MyS3.root_resource_id}"
#   http_method = "${aws_api_gateway_method.GetBuckets.http_method}"
#   status_code = "${aws_api_gateway_method_response.500.status_code}"

#   selection_pattern = "5\\d{2}"
# }

resource "aws_api_gateway_deployment" "S3APIDeployment" {
  depends_on  = ["aws_api_gateway_integration.S3Integration"]
  rest_api_id = "${aws_api_gateway_rest_api.MyS3.id}"
  stage_name  = "MyS3"
}
