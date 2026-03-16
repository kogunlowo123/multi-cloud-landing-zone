# -----------------------------------------------------------------------------
# Folder Hierarchy
# -----------------------------------------------------------------------------
resource "google_folder" "bootstrap" {
  display_name = "Bootstrap"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "common" {
  display_name = "Common"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "production" {
  display_name = "Production"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "non_production" {
  display_name = "Non-Production"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "development" {
  display_name = "Development"
  parent       = "organizations/${var.org_id}"
}

# -----------------------------------------------------------------------------
# Org Policies
# -----------------------------------------------------------------------------
resource "google_organization_policy" "allowed_locations" {
  org_id     = var.org_id
  constraint = "gcp.resourceLocations"

  list_policy {
    allow {
      values = var.allowed_regions
    }
  }
}

resource "google_organization_policy" "uniform_bucket_access" {
  org_id     = var.org_id
  constraint = "storage.uniformBucketLevelAccess"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "disable_serial_port" {
  org_id     = var.org_id
  constraint = "compute.disableSerialPortAccess"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "require_os_login" {
  org_id     = var.org_id
  constraint = "compute.requireOsLogin"

  boolean_policy {
    enforced = true
  }
}

# -----------------------------------------------------------------------------
# Seed Project
# -----------------------------------------------------------------------------
resource "google_project" "seed" {
  name            = "${var.project_prefix}-seed"
  project_id      = "${var.project_prefix}-seed"
  folder_id       = google_folder.bootstrap.name
  billing_account = var.billing_account

  labels = var.labels
}

# -----------------------------------------------------------------------------
# Logging Project
# -----------------------------------------------------------------------------
resource "google_project" "logging" {
  name            = "${var.project_prefix}-logging"
  project_id      = "${var.project_prefix}-logging"
  folder_id       = google_folder.common.name
  billing_account = var.billing_account

  labels = var.labels
}

# -----------------------------------------------------------------------------
# Networking Project
# -----------------------------------------------------------------------------
resource "google_project" "networking" {
  name            = "${var.project_prefix}-networking"
  project_id      = "${var.project_prefix}-networking"
  folder_id       = google_folder.common.name
  billing_account = var.billing_account

  labels = var.labels
}

# -----------------------------------------------------------------------------
# Security Project
# -----------------------------------------------------------------------------
resource "google_project" "security" {
  name            = "${var.project_prefix}-security"
  project_id      = "${var.project_prefix}-security"
  folder_id       = google_folder.common.name
  billing_account = var.billing_account

  labels = var.labels
}

# -----------------------------------------------------------------------------
# Organization Sink for centralized logging
# -----------------------------------------------------------------------------
resource "google_logging_organization_sink" "central" {
  name        = "central-log-sink"
  org_id      = var.org_id
  destination = "storage.googleapis.com/${google_project.logging.project_id}-logs"

  include_children = true

  filter = "severity >= WARNING"
}
