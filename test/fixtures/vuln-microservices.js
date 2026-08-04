app.get("/api/users", handler);
app.post("/api/users", handler);
const cors = { origin: "*" };
const bodyLimit = 0;
const timeout = 0;
proxy_pass("http://localhost:8080");
proxy_pass("http://" + req.path);
graphql({ maxDepth: 0, maxComplexity: 0, batch: true });
type Mutation { updateUser(input: String): User }
circuitBreaker: false;
maxRetries: Infinity;
idempotency: false;
proxy_pass http://localhost:8080;
proxy_pass http://$path;
app.listen(80);
User.findAll();
const graphql = {};
bulkhead: false
