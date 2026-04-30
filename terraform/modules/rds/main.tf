resource "random_password" "db" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "db" {
  name = "recipe-box/db-credentials"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = "postgres"
    password = random_password.db.result
    host     = aws_db_instance.main.address
    port     = 5432
    database = "app"
  })
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-rds"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "app"
  username               = "postgres"
  password               = random_password.db.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.sg_rds_id]
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false
  apply_immediately      = true
  storage_encrypted      = false
  backup_retention_period = 0
}
