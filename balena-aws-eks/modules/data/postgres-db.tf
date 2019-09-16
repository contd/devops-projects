data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  name               = "rds${var.postgres["environment"]}EnhancedMonitoringRole"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = aws_iam_role.enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_security_group" "postgresql" {
  vpc_id = var.vpc_id

  tags {
    Name        = "DatabaseSecurityGroup"
    Project     = var.postgres["project"]
    Environment = var.postgres["environment"]
  }
}

resource "aws_db_instance" "postgresql" {
  allocated_storage          = 32
  engine                     = "postgres"
  engine_version             = var.postgres["engine_version"]
  identifier                 = var.postgres["database_identifier"]
  snapshot_identifier        = var.postgres["snapshot_identifier"]
  instance_class             = var.postgres["instance_class"]
  storage_type               = var.postgres["storage_type"]
  iops                       = var.postgres["iops"]
  name                       = var.postgres["database_name"]
  password                   = var.postgres["database_password"]
  username                   = var.postgres["database_username"]
  backup_retention_period    = var.postgres["backup_retention_period"]
  backup_window              = var.postgres["backup_window"]
  maintenance_window         = var.postgres["maintenance_window"]
  auto_minor_version_upgrade = var.postgres["auto_minor_version_upgrade"]
  final_snapshot_identifier  = var.postgres["final_snapshot_identifier"]
  skip_final_snapshot        = var.postgres["skip_final_snapshot"]
  copy_tags_to_snapshot      = var.postgres["copy_tags_to_snapshot"]
  multi_az                   = var.postgres["multi_az"]
  port                       = var.postgres["database_port"]
  vpc_security_group_ids     = [aws_security_group.postgresql.id]
  db_subnet_group_name       = var.subnet_group
  parameter_group_name       = var.postgres["parameter_group"]
  storage_encrypted          = var.postgres["storage_encrypted"]
  monitoring_interval        = var.postgres["monitoring_interval"]
  monitoring_role_arn        = aws_iam_role.enhanced_monitoring.arn

  tags {
    Name        = "DatabaseServer"
    Project     = var.postgres["project"]
    Environment = var.postgres["environment"]
  }
}
