# go-boilerplate
A minimalistic Go boilerplate.

Includes:
- [gofumpt](https://pkg.go.dev/mvdan.cc/gofumpt)
- [golangci-lint](https://golangci-lint.run)
- [gotest](https://pkg.go.dev/gotest.tools/gotestsum)
- [govuln](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)

## Requirements
- Go 1.24+
- [pre-commit](https://pre-commit.com)

## Using
```shell
git clone https://github.com/alexferl/go-boilerplate.git myapp
cd myapp
make dev
```

See which other commands are available with:
```shell
make help
```
