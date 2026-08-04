# machin-secure — Vision & North Star

> A security auditor where the tool owns **no model** — the calling agent *is* the LLM.

## The problem

Static analysis tools fall into two camps, both broken for agent-first use:

1. **Heavyweight SAST** (Semgrep, CodeQL, Strix): powerful, but they own the
   whole pipeline — the rules, the triage, sometimes the LLM call that filters
   false positives. They need a server, a database, a Docker sandbox, or an API
   key. An agent that already *is* an LLM ends up paying for a second LLM inside
   the tool, or fighting the tool's opinions about what matters.

2. **Grep-in-a-loop**: cheap, but no structure — no stable finding IDs, no
   persisted verdicts, no CI integration, no severity taxonomy. Every run starts
   from zero; the agent re-triages the same false positives forever.

## The north star

**The tool owns the deterministic part. The agent owns the judgment.**

```
rules.json (the moat) --> secure binary (the engine) --> JSONL / SARIF findings
                                                              |
                                          calling agent reads + reasons (its own LLM)
                                                              |
                                     secure verdict <id> keep|drop --> persisted store
```

`secure` is a regex engine with stable finding IDs and a persisted verdict
store. It never calls an LLM, never holds an API key, never makes a network
call to a model provider. The agent driving `secure` (Devin, Claude Code, any
coding agent) already has a model — it reads the findings, reasons with its own
context, and writes back a verdict that survives across scans. Same BYOK split
as `grepapi`'s `/v1/brief`: the tool returns structured data, the operator's
own LLM completes the reasoning.

## What this means in practice

| Decision | Consequence |
|----------|-------------|
| No LLM client in the tool | No API key, no budget, no network call. The agent's own model is the filter. |
| `rules.json` is data, not code | Add detections without recompiling. The rule pack is the actual product. |
| Stable finding IDs (`sha256(rule\|file\|line)`) | Verdicts persist across scans, across machines, across agents. |
| SARIF 2.1.0 output | Drops into GitHub Code Scanning, VS Code, any SARIF consumer. CI-native. |
| `--diff` / `--diff-base` | Scans only changed files — 0.23s on a 10k-file repo with 8 changed files. The actual fix for CI latency. |
| No Docker, no browser, no sandbox | Read-only static analysis. Never executes target code, never mutates the repo. |

## What it is NOT (on purpose)

- **Not an agent loop.** No tool-calling LLM, no multi-step reasoning inside the
  tool. The agent that runs `secure` does the reasoning; `secure` does the
  scanning.
- **Not a report generator.** `--hart` prints guidance for the agent to author
  and publish its own HTML report with its own model. The tool doesn't bake
  prose-generation judgment into a binary that otherwise owns none.
- **Not an index or database.** The filesystem is scanned fresh every time —
  freshness over sophistication. The one piece of state that persists is the
  verdict store, and only because it's the *agent's* memory, not a cache the
  tool invents.
- **Not AST-based (yet).** Regex over lines is v0 — deterministic, fast, and
  good enough for the patterns that matter most (secrets, injection, weak
  crypto, TLS bypass). Tree-sitter precision is a possible v2, but it breaks
  the single-binary KISS model and the agent-verdict filter already handles
  false positives. KISS first; complexity only when it earns its keep.

## The moat

The scanner is ~500 lines of MFL. **`rules.json` is the actual product.** The
detection quality lives in the rule pack — the patterns, the CWE tags, the
severity calibration, the language coverage. The engine is interchangeable; the
rules are the accumulated knowledge. This is why the rules are plain data read
fresh from disk every run: the moat must be editable without recompiling the
engine.

## Roadmap (only build what earns its keep)

- [x] **v0 — deterministic regex engine**: JSONL findings, stable IDs, exit codes.
- [x] **v1 — agent-managed verdicts**: `secure verdict keep|drop`, persisted store, `--show-all`.
- [x] **v2 — performance**: `--diff` / `--diff-base` for CI, `--workers N` for parallel full scans.
- [x] **v3 — CI integration**: SARIF 2.1.0 output, reusable GitHub Action, `security-events: write`.
- [x] **v4 — rule pack expansion**: 84 CWE-tagged detections across 16 languages.
- [x] **v5 — IaC + frameworks + more CWE**: 119 rules across 17 languages — Terraform/Kubernetes/Docker IaC misconfigurations, Django/Flask/FastAPI/Spring framework rules, CSRF/mass-assignment/ReDoS/log-injection/weak-TLS.
- [x] **v6 — CI/CD + deps/config + auth/session**: 147 rules across 24 languages — GitHub Actions pipeline security (pull_request_target, write-all, secrets in run, script injection), dependency hardening (unpinned requirements/package.json/Cargo.toml/Gemfile, config file secrets), auth/session (JWT alg:none in 4 languages, unsalted hashes, bcrypt low rounds, session fixation, plaintext password scheme, weak password length, non-crypto random for secrets).
- [ ] **Baseline mode**: snapshot current findings as accepted state; future runs surface only *new* findings. Pairs with `--diff` — the path to usable static analysis in real codebases (you can't fix 500 legacy issues at once).
- [ ] **Community rule packs**: split `rules.json` into per-language or per-framework packs that can be contributed independently of the engine.
- [ ] **Tree-sitter precision** (maybe): AST-based matching for fewer false positives. High effort, breaks single-binary KISS — only if the agent-verdict filter proves insufficient in practice.

## Design principles

1. **KISS.** The 15-lines-of-bash lesson: a deterministic regex engine over the
   filesystem finds most of what a heavyweight agent finds, with none of the
   infrastructure, cost, or attack surface. Complexity only when it earns its
   keep.
2. **Agent-first.** Output is JSONL/SARIF, not prose. No TUI, no dashboard. The
   tool is shaped for an agent to pipe, parse, and act on — not for a human to
   stare at.
3. **BYOK.** The tool never duplicates the LLM the operator already has. No
   model client, no API key, no network call to a provider. The agent is the
   LLM.
4. **Data over code.** The rules are the moat; the engine is interchangeable.
   Edit detections without recompiling.
5. **Freshness over sophistication.** No index, no database, no run journal.
   Scan the filesystem every time. The one persistent state is the agent's own
   verdict memory.
