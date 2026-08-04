import os
DEBUG = True
ALLOWED_HOSTS = ["*"]
SECURE_SSL_REDIRECT = False
SESSION_COOKIE_SECURE = False
SECRET_KEY = "hardcodeddjangokey123456"

from django.views.decorators.csrf import csrf_exempt
@csrf_exempt
def api(request):
    return HttpResponse("ok")
