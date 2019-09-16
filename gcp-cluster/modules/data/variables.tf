// Region to build into
variable "region" {
  type        = string
  description = "Used GCP Region."
}

//
variable "dbname" {
  type        = string
  description = "Name of the GCP hosted Postgres database"
}

//
variable "dbtier" {
  type        = string
  description = "Tier of the GCP hosted Postgres database"
}
