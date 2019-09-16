resource "google_sql_database_instance" "master" {
  name             = "postgress-${var.dbname}"
  database_version = "POSTGRES_9_6"
  region           = var.region

  settings {
    tier = var.dbtier
  }
}

//
resource "google_sql_database" "balena" {
  name     = var.dbname
  instance = google_sql_database_instance.master.name
}

//
output "gcp_postgres_self_link" {
  value = google_sql_database_instance.master.self_link
}

//
output "gcp_postgres_conn_name" {
  value = google_sql_database_instance.master.connection_name
}

//
output "gcp_balenadb_selflink" {
  value = google_sql_database.balena.self_link
}
