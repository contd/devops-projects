provider "google" {
  credentials = file("./account.json")
  project     = var.project
  region      = var.region
}

provider "kubernetes" {}
provider "helm" {}
