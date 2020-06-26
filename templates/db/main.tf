resource "aws_db_instance" "default" {
  identifier = "flask-react-demo-db"
  allocated_storage = 20
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "11.4"
  instance_class = "db.m5.large"
  name = "users_prod"
  username = var.master_username
  password = var.master_password
  publicly_accessible = "false"
  port = 5432
  multi_az = false
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "main" {
  name = "bbdsubnetgroup"
  subnet_ids = var.subnet_ids
}