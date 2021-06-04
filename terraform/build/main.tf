terraform {
  required_version = ">= 0.13"
   backend "s3" {
      bucket = "suriya-build-artifacts"
      key    = "sns.tfstate"
      workspace_key_prefix="sns"
   }
  # backend "s3" {
  #   bucket = "suriya-build-artifacts"
  #   key    = "myapp/myapp.tfstate"
  #   region = "ap-south-1"
  # }
}

provider "aws" {
  region = "ap-south-1"
}

variable "environment" {
  
}

resource "aws_sns_topic" "user_updates" {
  name                        = "user-updates-${var.environment}-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}

resource "aws_sqs_queue" "user_updates_queue" {
  name                        = "user-updates-${var.environment}-queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.user_updates_queue.arn
}

# resource "aws_instance" "web" {
#   ami           = "ami-0e306788ff2473ccb"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "HelloWorld-${var.environment}"
#   }
# }

# output "instance_arn" {
#   value = "${aws_instance.web.arn}"
# }

# resource "aws_s3_bucket" "terraform_state" {
#   # TODO: change this to your own name! S3 bucket names must be *globally* unique.
#   bucket = "suriya-tf-state-bucket"

#   # Enable versioning so we can see the full revision history of our
#   # state files
#   versioning {
#     enabled = true
#   }

#   # Enable server-side encryption by default
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }

# resource "aws_s3_bucket" "b" {
#   bucket = "my-tf-test-bucket"
#   acl    = "private"

#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }
# }
