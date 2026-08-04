import subprocess, traceback, tempfile
subprocess.Popen("ls " + user_input, shell=True)
traceback.print_exc()
tempfile.mktemp()
User.objects.create(**req.body)
