resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id

  # Allow SSH from anywhere (Restrict this in production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Prometheus (9090) access to Bastion
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Alertmanager (9093) access to Bastion
  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Node Exporter (9100) access to Bastion
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion-sg" }
}

resource "aws_security_group" "prometheus" {
  vpc_id = var.vpc_id

  # Allow SSH from Bastion Host ONLY
  ingress {
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.bastion.id
  }

  # Allow Prometheus (9090) from Bastion
  ingress {
    from_port                = 9090
    to_port                  = 9090
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.bastion.id
  }

  # Allow Alertmanager (9093) from Bastion
  ingress {
    from_port                = 9093
    to_port                  = 9093
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.bastion.id
  }

  # Allow Node Exporter (9100) from Bastion
  ingress {
    from_port                = 9100
    to_port                  = 9100
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.bastion.id
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "prometheus-sg" }
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "prometheus_sg_id" {
  value = aws_security_group.prometheus.id
}
