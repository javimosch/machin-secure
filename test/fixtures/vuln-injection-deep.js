const ejs = require("ejs");
const pug = require("pug");
const Handlebars = require("handlebars");
ejs.render(req.body);
pug.render(req.body);
Handlebars.compile(req.body)();
exec(req.body);
execSync(req.body);
spawn(req.body);
knex.raw(req.body);
sequelize.literal(req.body);
$queryRaw(req.body);
const csrf = { token: Math.random() };
app.get("/delete/:id", handler);
dangerouslySetInnerHTML = req.body;
v-html = req.body;
@html req.body;
res.send("<div>" + req.body + "</div>");
{$regex: req.body}
{$in: req.body}
getRepository().query(req.body)
sameSite: "None"
csrf token
{@html req.body}
