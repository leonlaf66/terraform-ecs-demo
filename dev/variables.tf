variable "aws_region" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "us-east-1"
}

variable "manual_image_tag" {
  description = "It will overiwrite the tag from ssm param"
  type        = string
  default     = null
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["kraken-vpc-dev"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Private"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
}

resource "terraform_data" "image_tag_check" {
  input = nonsensitive(local.final_tag)
}

data "aws_ssm_parameter" "latest_tag" {  
  name = "/ecs/app/version/nodejs"
}