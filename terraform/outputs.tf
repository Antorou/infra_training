output "db_secret_arn" {
  value = module.rds.db_secret_arn
}

output "db_endpoint" {
  value     = module.rds.db_endpoint
  sensitive = true
}
