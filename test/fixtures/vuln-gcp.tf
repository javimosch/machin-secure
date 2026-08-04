resource "google_storage_bucket" "data" {
  uniformBucketLevelAccess = false
}
resource "google_compute_firewall" "open" {
  source_ranges = ["0.0.0.0/0"]
}
resource "google_sql_database_instance" "db" {
  settings { ip_configuration { ipv4_enabled = true } }
  ssl_mode = "DISABLED"
  require_ssl = false
}
resource "google_storage_bucket" "ver" {
  versioning { enabled = false }
}
resource "google_project_iam_binding" "pub" {
  members = ["allUsers"]
}
resource "google_cloudfunctions_function" "fn" {
  trigger_http = true
  ingress_settings = "ALLOW_ALL"
}
resource "google_compute_instance" "vm" {
  enable_serial_port = true
}
service_account_key = "AIzaSyD-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
substitutions: true
special_group = "allAuthenticatedUsers"
iam_member = "allUsers"
members = ["allUsers"] roles/cloudkms
