const password = "hardcodedpass123";
app.use(json());
db.User.create(req.body);
console.log(req.headers);
if (req.headers.Origin === "*") { next(); }
res.cookie("s", "v", { sameSite: "none" });
const evil = /(a+)+$/;
