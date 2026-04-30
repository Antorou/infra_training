output "db_secret_arn" {
  value = module.rds.db_secret_arn
}

output "rds_endpoint" {
  value     = module.rds.db_endpoint
  sensitive = true
}

output "ecs_execution_role_arn" {
  value = module.iam.ecs_execution_role_arn
}

output "ecs_task_role_arn" {
  value = module.iam.ecs_task_role_arn
}

output "s3_bucket_name" {
  value = module.iam.s3_bucket_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "frontend_ecr_url" {
  value = module.ecr.frontend_repo_url
}

output "backend_ecr_url" {
  value = module.ecr.backend_repo_url
}
