module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "security_groups" {
  source       = "./modules/security-groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  sg_rds_id          = module.security_groups.sg_rds_id
}

module "iam" {
  source        = "./modules/iam"
  project_name  = var.project_name
  account_id    = var.account_id
  db_secret_arn = module.rds.db_secret_arn
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  sg_alb_id         = module.security_groups.sg_alb_id
}

module "ecs" {
  source       = "./modules/ecs"
  project_name = var.project_name
  aws_region   = var.aws_region

  backend_repo_url  = module.ecr.backend_repo_url
  frontend_repo_url = module.ecr.frontend_repo_url

  db_secret_arn  = module.rds.db_secret_arn
  s3_bucket_name = module.iam.s3_bucket_name

  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn

  public_subnet_ids = module.vpc.public_subnet_ids
  sg_backend_id     = module.security_groups.sg_backend_id
  sg_frontend_id    = module.security_groups.sg_frontend_id

  backend_target_group_arn  = module.alb.backend_target_group_arn
  frontend_target_group_arn = module.alb.frontend_target_group_arn
}
