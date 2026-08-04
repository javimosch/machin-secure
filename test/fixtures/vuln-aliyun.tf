resource "alicloud_security_group_rule" "open" {
  cidr_ip = "0.0.0.0/0"
}
resource "alicloud_oss_bucket" "pub" {
  acl = "public-read"
}
resource "alicloud_slb" "internet" {
  address_type = "internet"
}
resource "alicloud_rds_instance" "db" {
  ssl_status = "disabled"
}
resource "alicloud_instance" "vm" {
  key_name = "default"
}
instance_type = "rds-public"
