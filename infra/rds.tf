resource "aws_db_instance" "main" {
  engine                 = "postgres"
  engine_version         = "15.15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = var.db_name
  username               = jsondecode(aws_secretsmanager_secret_version.db_credentials.secret_string).username
  password               = jsondecode(aws_secretsmanager_secret_version.db_credentials.secret_string).password
  port                   = 5432
  vpc_security_group_ids = [aws_security_group.pg_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  availability_zone      = "us-east-1a"
  skip_final_snapshot    = true
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "db_credentials1"
  description = "Credentials for the database"
}


resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "postgres"
    password = "password"
  })
}
