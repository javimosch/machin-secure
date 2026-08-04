# machin-secure

KISS, agent-first, machine-first security auditor. Not for humans: output is
JSONL by default, no TUI, no prose. Clean-room inspired by usestrix/strix but
deliberately much simpler — a deterministic regex rule engine, no LLM agent
loop, no Docker sandbox, no browser automation.

## What it is

```
rules.json (the moat) --> secure binary (the engine) --> JSONL findings on stdout
                                                                   |
                                            calling agent reads + reasons (its own LLM)
                                                                   |
                                       secure verdict <id> keep|drop  --> persisted store
```

One MFL source file (`src/secure.src`), compiled to a single static binary
with `machin`. `rules.json` is data, read fresh from disk every run — edit it
to add detections without recompiling.

**No LLM client is built in — on purpose.** The tool that runs `secure` (Devin,
Claude Code, any coding agent) already *is* an LLM. There is no reason for
`secure` to also hold an OpenAI/OpenRouter API key, manage a budget, or make a
network call to a model provider just to classify its own output. Instead:

1. `secure --target .` emits JSONL findings, each with a stable `id`
   (`sha256(rule|file|line-text)`).
2. The calling agent reads the JSONL with its own reasoning and decides which
   findings are false positives.
3. It records that judgment with `secure verdict --target . <id> drop --reason
   "..."` (or batches many via `secure verdict --target . --stdin`, feeding
   JSON Lines of `{"id":...,"verdict":"keep"|"drop","reason":...}`).
4. Future scans of the same target automatically suppress `drop`-verdicted
   findings (see them again with `--show-all`) and report a `suppressed`
   count in `--summary`.

This is the same split used in `~/ai/grepapi`: the tool returns structured
data (there: "briefs"; here: findings) and never runs or bills an LLM
completion itself — the *operator's own LLM* is the one that reasons. Here the
"operator" is whichever agent is driving `secure`.

The verdict store is a plain JSON file, `<target-dir>/.machin-secure.verdicts.json`
by default (override with `--store PATH`), excluded from scanning itself.

## Build

```sh
./build.sh          # machin encode + machin build -> ./secure (single binary)
```

## Usage

```sh
./secure --target ./some/repo                          # JSONL findings on stdout
./secure --target ./some/repo --summary                 # one JSON summary object only
./secure --target ./some/repo --hart                    # also publish an HTML report to hart.intrane.fr
./secure --target ./some/repo --show-all                # include findings already verdicted 'drop'
./secure verdict --target ./some/repo <id> drop --reason "..."   # persist a false-positive judgment
./secure verdict --target ./some/repo --stdin           # batch verdicts via JSON Lines on stdin
./secure --help
./secure verdict --help
```

Exit codes: `0` clean, `1` error (e.g. bad target/rules), `2` high/critical
findings present. Designed to be piped: `./secure --target . | jq 'select(.severity=="critical")'`.

## Design decisions (why it's this simple)

- No agent loop, no tool-calling LLM, **no LLM API client of any kind**. The
  calling agent already is an LLM (Devin/Claude Code/etc.); it reads the
  JSONL, reasons with its own model, and writes back a verdict. `secure`
  never holds an API key or makes a network call to a model provider — see
  the BYOK split in `~/ai/grepapi` (`/v1/brief`: rules/data here, the
  operator's own LLM completes the reasoning there).
- No index, no database, no run journal. The filesystem is scanned fresh every
  time — freshness over sophistication. The one piece of state that *does*
  persist is the verdict store, and only because it's the agent's own memory,
  not a cache the tool invents.
- No Docker, no Playwright, no sandbox broker. Read-only static analysis only.
  It never executes target code and never mutates the target repo.
- `rules.json` is the actual product. The scanner is ~440 lines of MFL
  (finding engine + hart report generator + verdict store + CLI).

## Known limitations / next steps (only build if actually needed)

- **Perf**: full recursive scan of a very large repo (35k+ files) takes
  minutes (O(files × lines × applicable-rules) with the Go regexp-free POSIX
  ERE engine, no rule/line pre-indexing). Fine for local/CI use; a `--diff`
  mode (scan only `git diff --name-only` files) would fix CI latency without
  adding architecture — do that before anything fancier.
- **False positives**: rules like `js-hardcoded-secret` and `sql-string-concat`
  fire on Vue prop bindings, test fixtures, and other benign matches (verified
  against `~/pr/multi-assistant`). This is what `secure verdict` is for — the
  calling agent triages once, drops the noise, and it stays dropped. No LLM
  call needed inside the tool at all.
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
