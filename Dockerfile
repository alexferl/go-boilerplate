FROM golang:1.25-alpine AS builder
LABEL maintainer="Alexandre Ferland <me@alexferl.com>"

WORKDIR /build

RUN apk add --no-cache git
RUN adduser -D -u 1337 app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ARG GOOS=linux
ARG GOARCH=amd64

ENV GOOS=$GOOS
ENV GOARCH=$GOARCH

RUN CGO_ENABLED=0 go build ./cmd/app

FROM scratch
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /build/app /app

USER app

ENTRYPOINT ["/app"]
