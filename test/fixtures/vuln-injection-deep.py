from jinja2 import Template
from django.template import Template as DTemplate
import subprocess, os, ldap
render_template_string(req.body)
Template(req.body)
DTemplate(req.body)
subprocess.call(req.body, shell=True)
os.system(req.body)
subprocess.Popen("echo " + req.body, shell=True)
conn.search("dc=example", req.body)
User.objects.raw(req.body)
User.objects.extra(where=[req.body])
from sqlalchemy import text
session.execute(text(req.body))
hmac.compare_digest == True
mark_safe(req.body)
autoescape = False
