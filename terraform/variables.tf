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

variable "KEY_PAIR_NAME" {
  default = "influx_key"
}

variable "VPC" {
  default = ""
}

variable "SUBNET"{
  default = ""
}