const { exec } = require('child_process')
const https = require('https')

const api_key = "sk_live_1234567890abcdefghijkl"
const password = "super-secret-password-1234"

function runCmd(userInput) {
  exec("ls " + userInput, (e, out) => console.log(out))
}

function render(html) {
  document.getElementById('x').innerHTML = html
}

console.log("token is", token)

https.get('https://example.com', { rejectUnauthorized: false })
