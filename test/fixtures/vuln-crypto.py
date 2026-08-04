from Crypto.Cipher import AES
from Crypto.PublicKey import RSA
import hashlib

cipher = AES.new(key, AES.MODE_ECB)
iv = b"hardcodediv12345"
aes = AES.new(key, AES.MODE_CBC, iv)
rsa_key = RSA.generate(1024)
salt = b"hardcodedsalt123"
h = hashlib.md5(password.encode()).hexdigest()
