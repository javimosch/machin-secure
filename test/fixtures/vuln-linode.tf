resource "linode_firewall" "open" {
  inbound_rule { addresses { ipv4 = ["0.0.0.0/0"] } }
}
resource "linode_object_storage_bucket" "pub" {
  acl = "public-read"
}
