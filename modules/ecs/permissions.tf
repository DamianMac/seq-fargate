
resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role"
  assume_role_policy = file("../../policies/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = file("../../policies/ecs-service-role-policy.json")
  role   = aws_iam_role.ecs_service_role.id
}
