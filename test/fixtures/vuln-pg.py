import psycopg2
conn = "postgresql://user:pass@localhost/db"
cur.execute("SELECT * FROM users WHERE id=%s" % req.body["id"])
cur.execute("COPY data FROM STDIN")
db.query("SELECT * FROM users WHERE id=" + req.query.id)
conn = psycopg2.connect("host=db sslmode=disable")
conn = "postgresql://user:pass@localhost/db"
