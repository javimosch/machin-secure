# machin-secure

A KISS, **agent-first** security auditor. Not built for humans reading a
dashboard — built for an LLM agent (Devin, Claude Code, any coding agent) to
run in a loop, pipe, and act on. One ~88 KB static binary compiled from
[machin](https://github.com/javimosch/machin)/MFL. No Docker, no browser
automation, no LLM API client inside the tool itself.

**Docs site:** https://javimosch.github.io/machin-secure/ ·
**Vision & north star:** [`docs/VISION.md`](docs/VISION.md) ·
**Changelog:** [`docs/changelog.html`](docs/changelog.html)

```
rules.json (the moat) --> secure binary (the engine) --> JSONL findings on stdout
                                                                   |
                                            calling agent reads + reasons (its own LLM)
                                                                   |
                                       secure verdict <id> keep|drop  --> persisted store
```

## Why this exists

A clean-room, deliberately simplified take on [usestrix/strix](https://github.com/usestrix/strix)
(an AI pentesting agent with Docker sandboxes, Playwright, and an LLM tool-loop
driving the scan). The KISS lesson — [15 lines of bash beat a 3,000-line search
engine](https://blog.intrane.fr) — applies here too: a deterministic regex rule
engine over the filesystem finds most of what a heavyweight agent finds, with
none of the infrastructure, cost, or attack surface.

## What it does NOT do (on purpose)

- **No LLM client.** No OpenAI/OpenRouter key, no budget, no network call to a
  model provider. The agent driving `secure` already *is* an LLM — it reads
  the JSONL, reasons with its own model, and the tool never duplicates that.
- **No Docker sandbox, no browser automation, no exploit execution.** Read-only
  static analysis. It never runs target code and never mutates the target repo.
- **No index, no database, no run journal.** The filesystem is scanned fresh
  every time — freshness over sophistication.
- **No report generation.** `--hart` prints guidance (default instance, publish
  contract) pointing the agent at [hart.intrane.fr](https://hart.intrane.fr) —
  the agent authors and publishes its own HTML report with its own model.

## Usage

```sh
./build.sh                                              # machin encode + build -> ./secure

./secure --target ./some/repo                           # JSONL findings on stdout
./secure --target ./some/repo --summary                 # one JSON summary object
./secure --target ./some/repo --show-all                # include already-dropped findings
./secure --target ./some/repo --hart                    # print guidance for the agent's own hart report
./secure --target ./some/repo --diff                    # scan only working-tree-changed files (fast, CI/pre-commit)
./secure --target ./some/repo --diff-base origin/main   # scan only files changed vs a base ref (PR-scoped CI)
./secure --target ./some/repo --workers 16              # parallel full-audit scan (default: 8 workers)

./secure verdict --target ./some/repo <id> drop --reason "..."   # persist the agent's judgment
./secure verdict --target ./some/repo --stdin           # batch verdicts via JSON Lines
```

Exit codes: `0` clean · `1` error · `2` high/critical findings present.
Pipeable: `./secure --target . | jq 'select(.severity=="critical")'`.

## CI / GitHub Code Scanning

`--sarif` emits a [SARIF 2.1.0](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html)
report (validated against the official schema) that GitHub's Security tab, VS
Code's SARIF viewer, and any SARIF consumer read directly. Each rule carries a
CWE `helpUri`, a `level` (`error`/`warning`/`note`), and a GitHub
`security-severity` (0–10) so findings land in the right priority bucket:

```sh
./secure --target . --sarif > machin-secure.sarif
```

There's a reusable GitHub Action (this repo's `action.yml` + `Dockerfile`) that
builds the binary in a pinned multi-stage image and writes the SARIF file. Drop
this into `.github/workflows/machin-secure.yml` in any repo:

```yaml
name: machin-secure
on: [push, pull_request]
permissions:
  contents: read
  security-events: write   # required to upload SARIF
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: javimosch/machin-secure@v2
        with:
          target: '.'
      - uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: machin-secure.sarif
          category: machin-secure
```

The action exits `0` whether or not findings exist (so the SARIF upload always
runs); severity gating is left to GitHub code-scanning settings. Inputs:
`target` (default `.`), `rules` (default: the bundled rule pack),
`output` (default `machin-secure.sarif`).

## The verdict loop (instead of an LLM filter)

Every finding carries a stable `id` (`sha256(rule|file|line)`). Rather than
`secure` calling an LLM to triage its own false positives, the calling agent
does it with the model it already has, and persists the call:

```sh
./secure --target . | jq -c 'select(.rule=="js-hardcoded-secret")'
# agent reasons: this one is a Vue prop binding, not a secret
./secure verdict --target . <id> drop --reason "Vue prop binding, not a secret"
# future scans suppress it automatically; --show-all brings it back
```

Same BYOK split as [grepapi](https://github.com/javimosch/grepapi)'s `/v1/brief`:
the tool returns structured data, the operator's own LLM does the reasoning.

## Rules

`rules.json` — **1,000 CWE-tagged detections** covering secrets (AWS, GCP, Azure,
Stripe, Twilio, Slack, GitHub, GitLab, npm, PyPI, SendGrid, Mailgun, Discord,
private keys, connection strings), command injection (eval, exec, subprocess,
Runtime.exec), deserialization (pickle, marshal, PHP unserialize, Java
ObjectInputStream, XStream, BinaryFormatter, node-serialize), SSTI (Jinja, Mako,
Twig, Smarty, EJS, Pug, Handlebars, FreeMarker, Velocity, Thymeleaf), XSS
(dangerouslySetInnerHTML, v-html, @html, mark_safe, |raw, innerHTML), SQL
injection (raw queries, ORM injection, LIKE/ORDER BY/LIMIT/OFFSET injection),
NoSQL injection ($where, $ne, $regex, $in), LDAP injection, template injection,
XXE (all major XML parsers), weak crypto (MD2/MD4/MD5/SHA-0/SHA-1, 3DES, RC2/RC4,
Blowfish, ECB mode, small RSA/DH keys, PKCS1 v1.5), TLS misconfig (SSLv2/v3,
TLSv1.0/1.1, NULL ciphers, export ciphers), SSRF, open redirect, path traversal,
CSRF, CORS, mass assignment, ReDoS, log injection, IaC misconfigurations
(Terraform, CloudFormation, Ansible, Puppet, Chef, SaltStack, Pulumi, Helm),
container/K8s security (Dockerfile, pod securityContext, privileged pods,
hostPath, service mesh mTLS), serverless (Lambda, Fargate), CI/CD pipeline
security (GitHub Actions, dependency management, SBOM, SAST, secret scanning),
microservices/API gateway (gRPC, GraphQL, REST, Istio, circuit breakers, sagas),
auth/session security (OAuth, SAML, OIDC, JWT, MFA, session management,
password hashing), database deep dives (MongoDB, PostgreSQL, MySQL, Cassandra,
Neo4j, Couchbase, SQLite), logging/monitoring/error handling, concurrency/race
conditions/DoS, input validation/output encoding, info disclosure, framework
rules (Express, Next.js, Nuxt, Angular, Vue, Svelte, Rails, Laravel, Django,
Spring Boot, Flask), cloud (AWS, GCP, Azure, Alibaba, Cloudflare), mobile
security (Android/iOS), language deep dives (C/C++ format strings, Rust unsafe,
Go unsafe/cgo, Java JNDI/SpEL/XPath, C# Roslyn, Kotlin coroutines, Swift
keychain), and supply chain) across Python, JS/TS/Vue, Go, Rust, C/C++, C#,
Java/Kotlin, Ruby, Shell, Swift, PHP, YAML, Terraform, Dockerfiles, XML, TOML,
.properties, plist, INI, requirements.txt, Gemfile, SQL, HTML, CSS. It's plain
data, read fresh from disk every run — extend it without recompiling.

## Verified against

- Synthetic fixtures (`test/fixtures/`) — all expected findings fire.
- A 10.4k-file production Node.js monorepo — 1,950 findings including a real
  hardcoded GitHub PAT and private-key material in `.env.*.bak` files. Full
  parallel scan (8 workers): **1m28s** (down from ~4m37s single-threaded).
  `--diff` with 8 changed files: **0.23s**. Same 1,950 findings every way.
- A 36k-file Vue/TS monorepo — full scan in ~13 min pre-parallelization.
- A fully non-interactive `devin -p ... --permission-mode dangerous` run:
  scan → read hint → author HTML report → publish to hart.intrane.fr, with
  zero manual steps.

See [`AGENTS.md`](AGENTS.md) for design rationale, MFL gotchas, and internals.

## License

MIT
