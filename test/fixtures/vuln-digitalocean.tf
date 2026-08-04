resource "digitalocean_firewall" "open" {
  inbound_rule { source_addresses = ["0.0.0.0/0"] }
}
resource "digitalocean_spaces_bucket" "pub" {
  acl = "public-read"
}
resource "digitalocean_droplet" "vm" {
  ipv6 = true
}
