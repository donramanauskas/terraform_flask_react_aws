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