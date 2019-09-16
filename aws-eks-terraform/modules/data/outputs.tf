output "pg_id" {
  value = aws_db_instance.postgresql.id
}

output "pg_hostname" {
  value = aws_db_instance.postgresql.address
}

output "pg_port" {
  value = aws_db_instance.postgresql.port
}

output "pg_endpoint" {
  value = aws_db_instance.postgresql.endpoint
}