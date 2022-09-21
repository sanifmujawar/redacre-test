#=======================Ecs Cluster=================================
resource "aws_ecs_cluster" "red_acre" {
  name = "${var.default_tag.Project}-ecs"
}

