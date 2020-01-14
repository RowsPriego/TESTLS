provider "aws" {
  region = "us-west-2"
  access_key = "tree"
  secret_key = "tree"
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_requesting_account_id = true
  s3_force_path_style = true
  endpoints {
    s3  = "http://localhost:4572"
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  acl    = "public-read"
}