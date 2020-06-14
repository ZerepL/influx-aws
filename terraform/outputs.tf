
output "IP" {
  value       = aws_instance.influx_server.public_ip
  description = "The private ip of intance"
}
