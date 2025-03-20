resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.bastion_sg_id]
   tags = {
    Name        = "prometheus-server"
    fetch_name  = "prometheus-instance"
  }
}

resource "aws_instance" "prometheus" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.prometheus_sg_id]
  tags                   = { Name = "prometheus-server" }
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "prometheus_private_ip" {
  value = aws_instance.prometheus.private_ip
}

