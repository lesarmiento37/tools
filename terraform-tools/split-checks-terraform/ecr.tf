resource "aws_ecr_repository" "leonardo_repository" {
  name                 = var.ecr_name
  image_tag_mutability = var.ecr_mutability

  image_scanning_configuration {
    scan_on_push = true
  }
}