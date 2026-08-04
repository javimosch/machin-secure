package main
import "crypto/tls"
func f() {
  c := &tls.Config{MinVersion: tls.VersionTLS10}
  _ = c
}
