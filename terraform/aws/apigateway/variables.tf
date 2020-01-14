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