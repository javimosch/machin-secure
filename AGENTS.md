# machin-secure

KISS, agent-first, machine-first security auditor. Not for humans: output is
JSONL by default, no TUI, no prose. Clean-room inspired by usestrix/strix but
deliberately much simpler — a deterministic regex rule engine, no LLM agent
loop, no Docker sandbox, no browser automation.

## What it is

```
rules.json (the moat) --> secure binary (the engine) --> JSONL findings on stdout
```

One MFL source file (`src/secure.src`), compiled to a single static binary
with `machin`. `rules.json` is data, not code — edit it to add detections
without recompiling... actually it IS read at runtime from disk, so editing
`rules.json` takes effect immediately, no rebuild needed.

## Build

```sh
./build.sh          # machin encode + machin build -> ./secure (single binary)
```

## Usage

```sh
./secure --target ./some/repo                # JSONL findings on stdout
./secure --target ./some/repo --summary       # one JSON summary object only
./secure --target ./some/repo --hart          # also publish an HTML report to hart.intrane.fr
./secure --help
```

Exit codes: `0` clean, `1` error (e.g. bad target/rules), `2` high/critical
findings present. Designed to be piped: `./secure --target . | jq 'select(.severity=="critical")'`.

## Design decisions (why it's this simple)

- No agent loop, no tool-calling LLM. The regex engine finds 100% of what it
  finds; an LLM is a post-hoc filter (v1, not yet built), never the driver.
- No index, no database, no run journal. The filesystem is scanned fresh every
  time — freshness over sophistication.
- No Docker, no Playwright, no sandbox broker. Read-only static analysis only.
  It never executes target code and never mutates the target repo.
- `rules.json` is the actual product. The scanner is ~230 lines of MFL.

## Known limitations / next steps (only build if actually needed)

- **Perf**: full recursive scan of a very large repo (35k+ files) takes
  minutes (O(files × lines × applicable-rules) with the Go regexp-free POSIX
  ERE engine, no rule/line pre-indexing). Fine for local/CI use; a `--diff`
  mode (scan only `git diff --name-only` files) would fix CI latency without
  adding architecture — do that before anything fancier.
- **False positives**: rules like `js-hardcoded-secret` and `sql-string-concat`
  fire on Vue prop bindings, test fixtures, and other benign matches (verified
  against `~/pr/multi-assistant`). The intended fix, per plan, is a single
  batch LLM classification pass over the raw findings (keep/drop + reason),
  never giving the model tool-calling access — see the original design
  discussion for why.
- POSIX ERE has no lookahead — don't write rules assuming PCRE features
  (e.g. `(?!...)`) as they'll silently no-op.
- `json_get(json, path)` needs a leading `.` (e.g. `.url`, not `url`) and
  returns the raw JSON token — a string value comes back quoted; strip quotes
  before use (see `strip_quotes` in secure.src).
- MFL structs are pass-by-value; scanner state is kept in a package-level
  `var run = Run{...}` global rather than threaded through every function
  call, per `SPEC.md`'s documented global semantics.

## Verified against

- `test/fixtures/vuln.py`, `test/fixtures/vuln.js` — synthetic positives,
  all 14 expected findings fire.
- `~/pr/multi-assistant` — 10,398 files scanned, 1950 findings including a
  real hardcoded GitHub PAT and private-key material in `.env.*.bak` files.
- `~/pr/v3` — 35,865 files scanned in ~13 min, 1680 findings.
- `--hart` report published successfully to https://hart.intrane.fr.
