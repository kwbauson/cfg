variable "id" {
  type = string
}

resource "google_secret_manager_secret" "default" {
  secret_id = var.id
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "initial" {
  secret      = google_secret_manager_secret.default.id
  secret_data = "initial"
}

data "google_secret_manager_secret_version" "latest" {
  secret = google_secret_manager_secret_version.initial.secret
}

output "secret_value" {
  value     = data.google_secret_manager_secret_version.latest.secret_data
  sensitive = true
}
