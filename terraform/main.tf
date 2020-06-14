module "my_host" {
  source  = "jameswoolfenden/ip/http"
  version = "0.2.5"
}

resource "tls_private_key" "influx_tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "influx_key" {
  key_name   = var.KEY_PAIR_NAME
  public_key = tls_private_key.influx_tls.public_key_openssh
}

resource "local_file" "key" {
  content         = tls_private_key.influx_tls.private_key_pem
  filename        = "${path.module}/${aws_key_pair.influx_key.key_name}.pem"
  file_permission = "0600"
}

resource "aws_security_group" "influx_SG" {
  vpc_id      = var.VPC
  name        = "influx_SG"
  description = "Access to Influx Server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Web for all"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Web for all"
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Data input from telegraf agent"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${module.my_host.ip}/32"]
    description = "SSH from own IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = merge(var.TAGS)
}

resource "aws_instance" "influx_server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.influx_key.key_name
  security_groups = [aws_security_group.influx_SG.id]
  subnet_id       = var.SUBNET
  tags            = merge(var.TAGS)

  connection {
      type        = "ssh"
      user        = "ubuntu"
      agent       = "false"
      private_key = tls_private_key.influx_tls.private_key_pem
      host        = aws_instance.influx_server.public_ip
  }

  provisioner "local-exec" {
      inline = [
          "cat > ../ansible/playbooks/ip.yaml <<EOF",
          "---",
          " ip: ${aws_instance.influx_server.private_ip}",
          "EOF"
      ]
  }

  provisioner "local-exec" {
      inline = [
          "cat > hosts <<EOF",
          "[influx-server]",
          "influx_server ansible_host=${aws_instance.influx_server.private_ip}" 
      ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu --private-key -i hosts ${aws_key_pair.influx_key.key_name} ../ansible/playbooks/packages.yaml" 
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu --private-key -i hosts ${aws_key_pair.influx_key.key_name} ../ansible/playbooks/influx.yaml" 
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu --private-key -i hosts ${aws_key_pair.influx_key.key_name} ../ansible/playbooks/grafana.yaml" 
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu --private-key -i hosts ${aws_key_pair.influx_key.key_name} ../ansible/playbooks/nginx.yaml" 
  }


}
