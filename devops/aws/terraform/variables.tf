variable "vpc_id" {}
variable "public_subnets" {
  type = list(string)
}
variable "ecs_cluster_name" {}
variable "ecs_task_execution_role_arn" {}
variable "image_version" {}
variable "ecr_repo_url" {}