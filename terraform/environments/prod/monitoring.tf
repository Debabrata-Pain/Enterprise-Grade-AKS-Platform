module "log_analytics" {

  source = "../../modules/log-analytics"

  name = "${var.environment}-law"

  location = var.location

  resource_group_name = module.monitoring_rg.resource_group_name

  retention_in_days = 30

  tags = local.common_tags

}