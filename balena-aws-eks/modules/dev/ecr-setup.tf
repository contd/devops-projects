resource "aws_ecr_repository" "uiapp" {
  name = "ecr-repo-uiapp"
}

resource "aws_ecr_repository" "apiapp" {
  name = "ecr-repo-apiapp"
}

resource "aws_ecr_repository" "tools" {
  name = "ecr-repo-tools"
}

