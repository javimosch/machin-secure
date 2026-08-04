from urllib.request import urlopen
from jinja2 import Template
import ldap

url = urlopen(req.body["url"])
t = Template(req.body["template"])
result = ldap.search("cn=" + req.query["name"])
assert req.body["password"] == "secret"
print(f"token: {token}")
User.objects.filter(name=req.GET["name"])
api_url = "http://10.0.0.5:8080/api"
exec(req.body["code"])
