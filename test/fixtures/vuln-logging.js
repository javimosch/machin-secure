console.log("password: " + password);
console.log("secret: " + secret);
console.log("token: " + token);
console.log("credit card: " + cc);
console.log("ssn: " + ssn);
err.printStackTrace();
console.log(req.body);
console.log(authorization);
res.json({ error: err.message, stack: err.stack });
const verbose = true;
try { } catch (e) {}
const sentry = { dsn: "public" };
ROLLBAR_TOKEN = "abc123";
DD_API_KEY = "abc123def456";
NEW_RELIC_LICENSE_KEY = "abc123";
BUGSNAG_API_KEY = "abc123";
LOG_LEVEL = "DEBUG";
SPLUNK_TOKEN = "abc123";
catch (e) { throw new Error(e); }
fetch("https://user:pass@host.com/path");
/debug
/env
SUMO_LOGIC_ACCESS: "key"
catch (SQLException e) { System.out.println(e); }
console.log("https://user:pass@host.com/path");
