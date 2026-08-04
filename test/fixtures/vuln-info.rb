require 'digest/md5'
hash = Digest::MD5.hexdigest(password)
api_endpoint = "http://10.0.0.3:3000"
