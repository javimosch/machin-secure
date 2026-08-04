const express = require("express");
const app = express();
app.get("/", (req, res) => res.send("ok"));
app.use((err, req, res, next) => {
  debug: true, error: err.stack
});
