
output "IP" {
  value       = aws_instance.influx_server.public_ip
  description = "The public ip of intance"
}
