variable "TAGS" {
  type        = map(string)
  default     = {
    Name      = "Influx-server"
    Component = "InfluxDB"
    Location  = "AWS"
  }
}

variable "PROVIDER" {
  type         = map(string)
  default      = {
    Name       = "Influx-server"
    profile    = "influx-aws"
    aws_region = "us-east-1"
    path       = "$HOME/.aws/credentials"
  }
}

variable "VPC" {
  default = "vpc-57c9fa2d"
}

variable "SUBNET"{
  default = "subnet-6d62850b"
}

variable "AMI" {
  default = "ami-0affd4508a5d2481b"
}

variable "KEY_PAIR_NAME" {
  default = "influx_key"
}