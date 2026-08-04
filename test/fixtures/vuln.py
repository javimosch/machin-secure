import os
import pickle
import yaml
import hashlib

API_KEY = "sk_test_1234567890abcdefghijklmnop"
SECRET_KEY = "hardcoded-super-secret-value"

def run(cmd):
    return os.system(cmd)

def load(data):
    return pickle.loads(data)

def parse_yaml(s):
    return yaml.load(s)

def hash_pw(pw):
    return hashlib.md5(pw.encode()).hexdigest()

result = eval(input())
