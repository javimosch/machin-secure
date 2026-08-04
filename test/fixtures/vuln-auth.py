import hashlib, bcrypt, jwt, random, pickle, passlib
jwt.decode(token, key, algorithms=["none"])
hashed = hashlib.md5(password.encode()).hexdigest()
hashed2 = hashlib.sha256(password.encode()).hexdigest()
salt = bcrypt.gensalt(4)
JWT_SECRET = "hardcodedjwtsecret123"
session_id = req.body.get("session_id")
from passlib.hash import plaintext
ctx.use_scheme("plaintext")
secret_token = ''.join(random.choice("abc") for _ in range(32))
pickle.dumps(obj, protocol=2)
