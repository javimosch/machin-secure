const { ApolloServer } = require("apollo-server");
const WebSocket = require("ws");
const axios = require("axios");
const _ = require("lodash");

const server = new ApolloServer({ introspection: true, depthLimit: 0, complexity: 0 });
const wss = new WebSocket.Server({ verifyClient: (info, cb) => cb(true) });

_.merge(config, req.body);
obj["__proto__"] = {};
User.find({ $where: "this.name == '" + req.body.name + "'" });
User.find({ age: { $gt: req.body.age } });
ldap.search("cn=" + req.query.name);
res.render(req.body.template);
axios.get(req.body.url);
fetch(req.body.url);

console.log("debug");
const token = "hardcoded123";
res.redirect("http://api.internal.svc:8080/v1");
app.use(upload.any());
eval(req.body.code);
