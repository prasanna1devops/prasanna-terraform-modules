
module "service_accounts" {
  source = "./modules/service_accounts"

  ca_certificate_secret_id    = var.ca_certificate_secret_id
  enable_airgap               = local.enable_airgap
  is_replicated_deployment    = var.is_replicated_deployment
  tfe_license_secret_id       = var.tfe_license_secret_id
  namespace                   = var.namespace
  project                     = var.project
  ssl_certificate_secret      = var.ssl_certificate_secret
  ssl_private_key_secret      = var.ssl_private_key_secret
  existing_service_account_id = var.existing_service_account_id
  depends_on = [
    module.project_factory_project_services
  ]
}
