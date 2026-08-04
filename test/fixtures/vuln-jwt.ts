const token = jwt.sign(payload, "mysecretkey123", { algorithm: "none", expiresIn: "365d" });
jwt.verify(token, secret, { verifySignature: false, ignoreExpiration: true });
const alg = { algorithm: "HS256", publicKey: pubKey };
document.cookie = "token=" + token + "; httpOnly=false";
