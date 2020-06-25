resource "aws_ecr_repository" "test_driven_client" {
  name = "test-driven-client"
}

resource "aws_ecr_repository" "test_driven_user" {
  name = "test-driven-user"
}