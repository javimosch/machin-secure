package main
import (
  "github.com/golang-jwt/jwt/v5"
  mathrand "math/rand"
)
func f() {
  token := jwt.NewWithClaims(jwt.SigningMethodNone, claims)
  _ = token
  _ = mathrand.Intn(secret)
}
