# August 2026 — Product

## From v0 to v1.0.0: a KISS security auditor, agent-first and CI-native

machin-secure shipped its first full release this month — a security auditor
where the tool owns **no model** and the calling agent *is* the LLM. The whole
journey from "15 lines of bash beat a 3,000-line search engine" to a reusable
GitHub Action with SARIF output, in 8 commits.

### What landed

- **The core idea**: a deterministic regex rule engine over the filesystem,
  with stable finding IDs and a persisted verdict store. No LLM client inside
  the tool — the agent driving `secure` reads the JSONL, reasons with its own
  model, and writes back a verdict that survives across scans. Same BYOK split
  as grepapi's `/v1/brief`.

- **Agent-managed verdicts**: every finding carries a `sha256(rule|file|line)`
  ID. The calling agent triages false positives with `secure verdict <id> drop
  --reason "..."` (or batches via `--stdin`), and future scans suppress them
  automatically. The tool never calls an LLM to decide this itself.

- **Performance for two different situations**: `--diff` / `--diff-base` scans
  only git-changed files — 0.23s on a 10k-file repo with 8 changed files (the
  actual fix for CI latency). `--workers N` parallelizes full audits — 1m28s
  with 8 workers on the same repo, down from ~4m37s single-threaded. Same
  findings every way.

- **SARIF 2.1.0 output + reusable GitHub Action**: `--sarif` emits a
  schema-valid SARIF report (CWE helpUris, severity levels, GitHub
  security-severity 0–10) that drops into GitHub Code Scanning. The Docker
  action pins machin to an immutable commit, builds the binary, and writes the
  SARIF file — exit 0 on both clean and findings so `upload-sarif` always runs.

- **84 CWE-tagged rules across 16 languages**: secrets, command injection,
  deserialization, XSS, SSRF, XXE, weak crypto, TLS bypass, SQL injection,
  path traversal, CORS, open redirect, buffer overflow — across Python,
  JS/TS/Vue, Go, Rust, C/C++, C#, Java/Kotlin, Ruby, Shell, Swift, PHP, YAML,
  Dockerfiles, XML. The rule pack is the actual product; the engine is
  interchangeable.

- **Hart reporting (guidance, not generation)**: `--hart` prints a hint
  pointing the agent at the default hart instance and the publish contract.
  The tool deliberately does not author or publish the report itself — that
  would bake prose-generation judgment into a binary that owns none.

### Verified against

Synthetic fixtures across 11 languages (all 84 rules fire); a 10.4k-file
production Node.js monorepo (1,950 findings including a real hardcoded GitHub
PAT); a 36k-file Vue/TS monorepo; and a full non-interactive `devin -p` smoke
test that scanned, authored an HTML report, and published it to
hart.intrane.fr end-to-end with zero manual steps.
