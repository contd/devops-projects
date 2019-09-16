variable "vpc_id" {}
variable "subnet_group" {}
//
variable "postgres" {
  type = "map"
  default = {
    engine_version              = "9.5.2"
    identifier                  = ""
    snapshot_identifier         = ""
    instance_class              = "db.t2.micro"
    storage_type                = "gp2"
    iops                        = "0"
    name                        = "kumpf"
    password                    = ""
    username                    = "pgadmin"
    backup_retention_period     = "30"
    backup_window               = "04:00-04:30"
    maintenance_window          = "sun:04:30-sun:05:30"
    auto_minor_version_upgrade  = true
    final_snapshot_identifier   = "terraform-aws-postgresql-rds-snapshot"
    skip_final_snapshot         = true
    copy_tags_to_snapshot       = false
    multi_az                    = true
    port                        = "5432"
    parameter_group_name        = "default.postgres9.5"
    storage_encrypted           = false
    monitoring_interval         = "60"
    project                     = "devproject"
    environment                 = "dev"
    ok_actions                  = "list"
    insufficient_data_actions   = "list"
    alarm_cpu_threshold                = "75"
    alarm_disk_queue_threshold         = "10"
    alarm_free_disk_threshold          = "5000000000"
    alarm_free_memory_threshold        = "128000000"
    alarm_cpu_credit_balance_threshold = "30"
    alarm_actions                      = "list"
    ok_actions                         = "list"
    insufficient_data_actions          = "list"
  }
}