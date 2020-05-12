
output "IP" {
  value       = aws_instance.influx_server.public_ip
  description = "The private ip of intance"
}

output "SECRET_key" {
  value       = tls_private_key.influx_tls.private_key_pem
  description = "Secrete key .pem"
}