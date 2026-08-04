import jwt
token = jwt.encode(payload, "mysecretkey123", algorithm="none")
jwt.decode(token, "secret", options={"verify_signature": False, "ignore_expiration": True})
