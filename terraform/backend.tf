terraform {
    required_version = ">= 0.12.26"

    backend "s3" {
        bucket  = "terraform-tf-states"
        key     = "tfstates/influx-automation/influx-server-test.tfstate"
        region  = "us-east-1"
        profile = "influx-aws"
    }
}