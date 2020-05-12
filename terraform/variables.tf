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
    path       = "/home/lbperez/.aws/credentials"
  }
}

variable "SECURITY_GROUP" {
  default = ["sg-002bd7d024ba41c71"]
}
