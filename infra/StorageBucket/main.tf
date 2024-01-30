terraform {
  backend "gcs" {
    bucket = var.bucket # GCS bucket name to store terraform tfstate
    prefix = var.prefix              # Prefix name should be unique for each Terraform project having same remote state bucket.
  }
}

module "object_storage" {
  source = "../../modules/object_storage"

  name       = "${var.env}-${var.project_id}-bucket"
  project_id = var.project_id
  location   = var.location

  lifecycle_rules = [{
    action = {
      type = "Delete"
    }
    condition = {
      age            = 365
      with_state     = "ANY"
      matches_prefix = var.project_id
    }
  }]

  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "group:test-gcp-ops@test.blueprints.joonix.net"
  }]

  autoclass = true
}