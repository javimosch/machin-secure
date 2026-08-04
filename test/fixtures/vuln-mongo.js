db.users.find({ $where: function() { return this.name == req.body.name } });
db.users.find({ $expr: { $eq: [req.body.id] } });
db.users.find(req.body);
db.users.update(req.body, { $set: { status: 1 } });
const conn = "mongodb://user:pass@localhost:27017/db";
db.users.find({}, { allowDot: true });
const client = new MongoClient(url, { tls: false });
// --noauth flag
