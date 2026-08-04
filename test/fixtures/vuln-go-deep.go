package main
import (
    "fmt"
    "net/http"
    "unsafe"
    "C"
)
func main() {
    p := unsafe.Pointer(&x)
    q := fmt.Sprintf("SELECT * FROM users WHERE id=%d", id)
    http.ListenAndServe(":8080", nil)
    _ = q
    _ = p
}
