module "flask-react-demo-network" {
  source                = "./templates/network"
  flask_react_demo_cidr = var.vpc_cidr
  environment           = var.environment
  vpc_name              = var.vpc_name
  public_subnets        = var.public_subnets
  availability_zones    = var.availability_zones
}

module "flask-react-codebuild" {
  source = "./templates/codebuild"
  project_location = var.project_location
}

module "ecr" {
  source = "./templates/ecr"
}

module "db" {
  source = "./templates/db"
  subnet_ids = module.flask-react-demo-network.subnets
  master_password = var.master_password
  master_username = var.master_username
  availability_zones = var.availability_zones
}