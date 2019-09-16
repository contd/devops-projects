output "ecr_uiapp" {
  value = aws_ecr_repository.uiapp.repository_url
}
output "ecr_apiapp" {
  value = aws_ecr_repository.apiapp.repository_url
}
output "ecr_tools" {
  value = aws_ecr_repository.tools.repository_url
}