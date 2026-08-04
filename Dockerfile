# GitHub Action image for machin-secure.
# Multi-stage: build the static `secure` binary from source (machin + machin-secure),
# then copy just the binary + default rules into a minimal runtime image.
# The entrypoint runs the scan and writes SARIF; the caller's workflow uploads it
# with github/codeql-action/upload-sarif.

# ---- builder: Go + cc (machin is a Go compiler that emits C) ----
FROM golang:1.22-alpine AS builder
RUN apk add --no-cache gcc musl-dev curl ca-certificates

# Pin machin to an immutable commit SHA for reproducible action builds.
# Currently pinned to v0.123.0 (565c25c) — the release that added the 3-value
# stat/exec multi-assign this tool relies on. Bump when machin-secure needs a
# newer machin feature; a released tag can be used once v0.123.0 is tagged.
ARG MACHIN_REF=565c25c
RUN curl -sSL https://github.com/javimosch/machin/archive/${MACHIN_REF}.tar.gz \
    | tar xz -C / && mv /machin-*/ /machin
WORKDIR /machin
RUN go build -o /usr/local/bin/machin .

# ---- build machin-secure itself ----
WORKDIR /build
COPY src/secure.src ./src/secure.src
COPY build.sh ./
RUN ./build.sh

# ---- runtime: just the static binary + default rules ----
FROM alpine:3.20
RUN apk add --no-cache libgcc
COPY --from=builder /build/secure /usr/local/bin/secure
COPY rules.json /usr/local/share/machin-secure/rules.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
