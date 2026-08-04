package main
import ("net/http"; "crypto/md5"; "crypto/des"; "database/sql"; "crypto/tls")
func pwn(url, id string) {
  http.Get("https://"+url)
  _ = md5.New()
  _ = des.NewCipher([]byte("8bytekey"))
  db.Query("SELECT * FROM users WHERE id=" + id)
  tr := &http.Transport{TLSClientConfig: &tls.Config{InsecureSkipVerify: true}}
  _ = tr
}
var secret = "supersecrettoken123"
