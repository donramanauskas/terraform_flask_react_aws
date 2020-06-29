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
  account_id = var.account_id
  dns_name = "http://${module.flask-react-demo-network.load_balancer_dns_name}"
  rds_uri = "postgress://webapp:${var.master_password}@${module.db.db_endpoint}/users_prod"
  production_secret_key = var.production_secret_key
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