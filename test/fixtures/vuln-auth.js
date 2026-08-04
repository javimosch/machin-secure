const jwt = require("jsonwebtoken");
jwt.verify(token, secret, { algorithms: ["none"] });
const JWT_SECRET = "hardcodedjwtkey456";
req.session.id = req.body.sessionId;
const token = Math.random().toString() + secret;
const minLength = 6;
