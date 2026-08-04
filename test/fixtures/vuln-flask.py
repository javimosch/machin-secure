from flask import Flask
app = Flask(__name__)
app.secret_key = "flasksecretkey123456"
if __name__ == "__main__":
    app.run(debug=True)
