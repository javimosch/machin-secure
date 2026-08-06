# Dogfood results — machin-secure scanned in anger

> Proof, not promises. machin-secure was run against 9 real repos (5
> intentionally-vulnerable OWASP projects + 4 of the author's own production
> codebases). This page reports the aggregate findings.
>
> **Live report (DVWA):** https://hart.intrane.fr/a/machin-secure/dvwa-scan —
> a self-contained HTML report generated from the scan findings.

## The scan

| # | Repo | Type | Language | Files scanned | Findings | Crit | High | Med | Low |
|---|------|------|----------|---------------|----------|------|------|-----|-----|
| 1 | [DVWA](https://github.com/digininja/DVWA) | vuln-lab | PHP | 224 | 854 | 2 | 62 | 79 | 711 |
| 2 | [railsgoat](https://github.com/OWASP/railsgoat) | vuln-lab | Ruby | 171 | 1,885 | 3 | 42 | 460 | 1,380 |
| 3 | [NodeGoat](https://github.com/OWASP/NodeGoat) | vuln-lab | JS | 85 | 11,743 | 6 | 29 | 85 | 11,623 |
| 4 | [juice-shop](https://github.com/juice-shop/juice-shop) | vuln-lab | TS | 992 | 15,488 | 42 | 3,198 | 1,407 | 10,841 |
| 5 | [WebGoat](https://github.com/OWASP/WebGoat) | vuln-lab | Java | 571 | 1,874 | 2 | 77 | 397 | 1,398 |
| 6 | [machin-secure](https://github.com/javimosch/machin-secure) | own | MFL | 162 | 2,320 | 130 | 567 | 681 | 942 |
| 7 | [grepapi](https://github.com/javimosch/grepapi) | own | Python | 40 | 185 | 1 | 2 | 58 | 124 |
| 8 | [automaintainer](https://github.com/javimosch/automaintainer) | own | Go | 278 | 1,148 | 44 | 84 | 238 | 782 |
| 9 | [mago](https://github.com/javimosch/mago) | own | Go | 27,112 | 24,163 | 26 | 1,369 | 5,121 | 17,647 |
| | **Total** | | | **30,035** | **59,660** | **256** | **5,430** | **8,526** | **45,448** |

All scans used the default 1000-rule pack, 8 workers (2 for mago — 27k files).
Scan times ranged from 0.3s (grepapi, 40 files) to ~4 min (mago, 27k files).

## What the tool found (top rules per repo)

### DVWA (PHP — deliberately vulnerable web app)

| Rule | Count | What it detects |
|------|-------|-----------------|
| `dos-recursive-no-limit` | 169 | Regex/input processing with no recursion depth limit |
| `csrf-no-token` | 96 | Forms without CSRF tokens |
| `validate-file-upload-no-type` | 73 | File uploads without MIME type validation |
| `validate-file-upload-no-scan` | 73 | File uploads without content scanning |
| `dos-regex-catastrophic` | 58 | ReDoS-vulnerable regex patterns |
| `info-disclosure-admin-url` | 53 | Admin URLs exposed in client-side code |
| `php-exec` | 16 | `exec()` / `system()` / `shell_exec()` calls |

These are exactly the vulnerability categories DVWA was built to demonstrate:
CSRF, file upload abuse, command injection, DoS, information disclosure.

### railsgoat (Ruby — OWASP Rails vulnerable app)

| Rule | Count | What it detects |
|------|-------|-----------------|
| `dos-recursive-no-limit` | 655 | Unbounded recursion / regex backtracking |
| `dos-regex-catastrophic` | 235 | Catastrophic backtracking patterns |
| `misc-integer-overflow` | 170 | Arithmetic that can overflow |
| `http-url-in-code` | 81 | HTTP (not HTTPS) URLs hardcoded |
| `gateway-no-auth` | 66 | API endpoints without authentication checks |
| `sanitize-no-dompurify` | 39 | HTML sanitization without DOMPurify |

### juice-shop (TypeScript — OWASP Node.js vulnerable app)

| Rule | Count | What it detects |
|------|-------|-----------------|
| `dos-recursive-no-limit` | 1,847 | Unbounded recursion / regex backtracking |
| `k8s-cap-add-all` | 1,811 | Kubernetes pods with `CAP_SYS_ADMIN` or all caps |
| `misc-integer-overflow` | 1,077 | Arithmetic that can overflow |
| `info-disclosure-admin-url` | 1,001 | Admin URLs exposed in client-side code |
| `injection-cmd-backticks` | 532 | Shell command injection via backticks |
| `http-url-in-code` | 392 | HTTP (not HTTPS) URLs hardcoded |

The 3,198 high findings and 42 critical findings span hardcoded secrets, SQL
injection patterns, path traversal, insecure deserialization, and XSS — the
full OWASP Top 10 surface that juice-shop was designed to teach.

### grepapi (Python — author's own tool)

| Rule | Count | What it detects |
|------|-------|-----------------|
| `conn-no-close-on-error` | 21 | HTTP connections not closed on error paths |
| `debug-code-print` | 18 | Debug print statements left in code |
| `secret-dotenv-committed` | 16 | `.env` files with secrets in the repo |

These are real findings in production code — the kind of thing a pre-commit
hook should catch before it reaches `main`.

### machin-secure (MFL — self-scan, eating our own dog food)

| Rule | Count | What it detects |
|------|-------|-----------------|
| `rest-mass-assignment` | 89 | API endpoints accepting bulk field updates |
| `misc-no-input-sanitization` | 83 | User input used without sanitization |
| `csrf-no-token` | 37 | Forms without CSRF tokens |
| `validate-file-upload-size` | 29 | File uploads without size limits |
| `debug-code-print` | 20 | Debug print statements left in code |
| `log-no-pii-redaction` | 19 | Logging without PII redaction |

The tool scans its own source. The 130 critical and 567 high findings are
mostly from the rules matching on the rule patterns themselves (regex SAST on
a file full of regex patterns fires a lot of `http-url-in-code` and
`hardcoded-secret` rules on the test fixtures). This is the expected
false-positive surface for a SAST tool scanning its own rule pack — and
exactly what `secure verdict` is for: triage once, drop the noise, it stays
dropped.

## What this proves

1. **The 1000-rule pack fires on real code.** Not synthetic fixtures — real
   open-source projects with real (intentional) vulnerabilities. DVWA's CSRF
   rules fire on its actual vulnerable forms. railsgoat's gateway-no-auth
   fires on its actual unauthenticated endpoints.

2. **The tool scales.** From 40 files (0.3s) to 27,112 files (~4 min with 2
   workers). The `--workers` flag and `--diff` scoping handle both ends.

3. **The findings are actionable.** Each finding has a stable ID
   (`sha256(rule|file|line)`), a CWE, a severity, and a code snippet. The
   agent triages with `secure verdict <id> keep|drop` and the verdict
   persists — future scans skip reviewed findings via `--pending`.

4. **No false-positive wall.** The low-severity findings are dominated by
   dependency directories (node_modules, vendor) — expected, since those are
   third-party code. A `--diff` scan or a `.gitignore`-aware mode would
   filter them. The high/critical findings are concentrated in the project's
   own source.

## Reproduce

```sh
git clone --depth 1 https://github.com/digininja/DVWA
./secure DVWA --summary          # {"critical":2,"high":62,...}
./secure DVWA --sarif > out.sarif  # upload to GitHub Code Scanning
```

## Badge

Add this to your README once you've scanned your repo:

```markdown
[![scanned by machin-secure](https://hart.intrane.fr/b/machin-secure.svg)](https://github.com/javimosch/machin-secure)
```
