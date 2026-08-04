const crypto = require("crypto");
const cipher = crypto.createCipheriv("aes-128-cbc", key, "hardcodediv");
const rsa = crypto.generateKeyPairSync("rsa", { modulusLength: 1024 });
const token = crypto.random(16);
const salt = "hardcodedsalt456";
