provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source         = "./modules/networking"
  vpc_cidr       = "192.168.0.0/16"
  public_subnet  = "192.168.10.0/24"
  private_subnet = "192.168.20.0/24"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

module "instances" {
  source            = "./modules/instances"
  ami_id            = "ami-0e1bed4f06a3b463d"
  instance_type     = "t2.micro"
  key_name          = "mykey"
  public_subnet_id  = module.networking.public_subnet_id
  private_subnet_id = module.networking.private_subnet_id
  bastion_sg_id     = module.security.bastion_sg_id
  prometheus_sg_id  = module.security.prometheus_sg_id
}

output "bastion_ip" {
  value = module.instances.bastion_ip
}

output "prometheus_private_ip" {
  value = module.instances.prometheus_private_ip
}
