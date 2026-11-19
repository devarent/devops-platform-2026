resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnets"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier                = var.identifier
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  allocated_storage         = var.allocated_storage
  db_name                   = var.database_name
  username                  = var.username
  password                  = var.password
  db_subnet_group_name      = aws_db_subnet_group.this.name
  vpc_security_group_ids    = var.vpc_security_group_ids
  multi_az                  = var.multi_az
  storage_encrypted         = var.storage_encrypted
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${var.identifier}-final"
  backup_retention_period   = var.backup_retention_period
  deletion_protection       = false
  publicly_accessible       = false
  apply_immediately         = true

  tags = var.tags
}
