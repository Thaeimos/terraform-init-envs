terraform {
  required_version = "~> 1.1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.30.0"
    }
    local = {
      source  = "hashicorp/aws"
      version = ">= 2.2.3"
    }
  }
}

provider "aws" {
  region = "${var.region}"
}

module "init-environments" {
  for_each              = toset(var.list_environments)
  source                = "github.com/Thaeimos/terraform-init-envs.git?ref=v1.1.4"
  environment           = each.value
  s3_dyn_name           = var.s3_dyn_name
  bucket_sse_algorithm  = var.bucket_sse_algorithm
}
