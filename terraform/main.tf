module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  my_ip_cidr         = var.my_ip_cidr
}

module "compute" {
  source = "./modules/compute"

  project_name      = var.project_name
  instance_type     = var.instance_type
  public_key_path   = var.public_key_path
  state_bucket_name = var.state_bucket_name
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.network.web_security_group_id
}
