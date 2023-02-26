# terraform {
#   backend "s3" {
#     bucket = "terraform-state-files-pankaj"
#     encrypt = true
#     key    = "jenkins/terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "terraform-state-files-pankaj"
#   }
# }
