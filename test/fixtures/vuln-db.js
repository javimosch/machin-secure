const query = "SELECT * FROM users ORDER BY " + req.body.sort;
redis.eval(req.body.script, 0);
es.search({ query: { query_string: { query: req.body.q } } });
