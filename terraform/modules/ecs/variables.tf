variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "backend_repo_url" {
  type = string
}

variable "frontend_repo_url" {
  type = string
}

variable "db_secret_arn" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "sg_backend_id" {
  type = string
}

variable "sg_frontend_id" {
  type = string
}

variable "backend_target_group_arn" {
  type = string
}

variable "frontend_target_group_arn" {
  type = string
}
