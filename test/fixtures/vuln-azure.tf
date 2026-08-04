resource "azurerm_storage_account" "data" {
  allow_blob_public_access = true
  min_tls_version = "TLS1_0"
  soft_delete_enabled = false
}
resource "azurerm_storage_container" "pub" {
  container_access_type = "blob"
}
resource "azurerm_mssql_firewall_rule" "all" {
  start_ip_address = "0.0.0.0" end_ip_address = "255.255.255.255"
}
resource "azurerm_network_security_rule" "open" {
  source_address_prefix = "*"
}
resource "azurerm_key_vault" "kv" {
  purge_protection_enabled = false
  network_acls { default_action = "Allow" }
}
resource "azurerm_app_service" "app" {
  https_only = false
}
resource "azurerm_container_registry" "acr" {
  admin_enabled = true
}
resource "azurerm_redis_cache" "redis" {
  public_network_access_enabled = true
}
resource "azurerm_managed_disk" "disk" {
  disk_encryption_set_id = ""
}
FUNCTION_KEY = "abc123def456ghi789jkl012mno"
