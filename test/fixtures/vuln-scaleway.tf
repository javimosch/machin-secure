resource "scaleway_security_group_rule" "open" {
  action = "accept" ip_range = "0.0.0.0/0"
}
resource "scaleway_rdb_cluster" "db" {
  public_network = true
}
