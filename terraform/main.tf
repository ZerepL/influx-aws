resource "tls_private_key" "influx_tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "influx_key" {
  key_name   = "influx_server"
  public_key = tls_private_key.influx_tls.public_key_openssh
}

resource "aws_instance" "influx_server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.influx_key.key_name
  security_groups = var.SECURITY_GROUP
  subnet_id       = "subnet-6d62850b"
  tags = merge(var.TAGS)

  connection {
      type        = "ssh"
      user        = "ubuntu"
      agent       = "false"
      private_key = tls_private_key.influx_tls.private_key_pem
      host        = aws_instance.influx_server.public_ip
  }

  provisioner "file" {
      source      = "./files/influx_install.sh"
      destination = "/tmp/influx_install.sh"
  }

  provisioner "file" {
      source      = "./files/nginx_conf.sh"
      destination = "/tmp/nginx_conf.sh"
  }

  provisioner "file" {
      source      = "./files/influxdb.conf"
      destination = "/tmp/influxdb.conf"
  }

  provisioner "remote-exec" {
      inline = [
          "chmod +x /tmp/influx_install.sh",
          "chmod +x /tmp/nginx_conf.sh",
          "/tmp/nginx_conf.sh ${aws_instance.influx_server.private_ip}",
          "/tmp/influx_install.sh"
      ]
  }
}