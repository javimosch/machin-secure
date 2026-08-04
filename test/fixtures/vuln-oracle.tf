resource "oci_core_security_list" "open" {
  source_cidr = "0.0.0.0/0"
}
resource "oci_objectstorage_bucket" "pub" {
  access_type = "ObjectRead"
}
