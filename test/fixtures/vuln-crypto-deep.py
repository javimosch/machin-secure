import hashlib, hmac, os
hashlib.md2(b"data")
hashlib.md4(b"data")
hashlib.ripemd160(b"data")
hashlib.whirlpool(b"data")
hashlib.sha0(b"data")
hashlib.sha1(b"data")
hashlib.sha224(b"data")
hmac.new(b"shortkey", b"msg", hashlib.sha256)
hashlib.md5(b"data")
random.seed(42)
random.randint(0, 100)
os.urandom(16)
from Crypto.Cipher import AES
AES.new(b"0" * 16, AES.MODE_ECB)
AES.new(b"0" * 16, AES.MODE_CBC, iv=b"0" * 16)
iv = "0000000000000000"
key = "hardcodedkey12345678"
PBKDF1(b"password", b"salt", 100)
iterations = 100
scrypt(b"password", salt, N=1024)
srand(42)
rand()
ECDSA secp224r1
