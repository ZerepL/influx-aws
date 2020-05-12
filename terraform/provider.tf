 
provider "aws" {
    region                  = var.PROVIDER["aws_region"]
    shared_credentials_file = var.PROVIDER["path"]
    profile                 = var.PROVIDER["profile"]
  
}