.PHONY: dev run build test cover cover-html lint tidy update-deps pre-commit

.DEFAULT: help
help:
	@echo "make dev"
	@echo "	setup development environment"
	@echo "make run"
	@echo "	run app"
	@echo "make build"
	@echo "	build app"
	@echo "make test"
	@echo "	run go test"
	@echo "make cover"
	@echo "	run go test with -cover"
	@echo "make cover-html"
	@echo "	run go test with -cover and show HTML"
	@echo "make lint"
	@echo "	lint code"
	@echo "make tidy"
	@echo "	run go mod tidy"
	@echo "make update-deps"
	@echo "	update dependencies"
	@echo "make pre-commit"
	@echo "	run pre-commit hooks"

VERSION := $(shell git describe --tags --always --dirty)

check-gofumpt:
ifeq (, $(shell which gofumpt))
	$(error "gofumpt not in $(PATH), gofumpt (https://pkg.go.dev/mvdan.cc/gofumpt) is required")
endif

check-golangci-lint:
ifeq (, $(shell which golangci-lint))
	$(error "golangci-lint not in $(PATH), golangci-lint (https://golangci-lint.run) is required")
endif

check-pre-commit:
ifeq (, $(shell which pre-commit))
	$(error "pre-commit not in $(PATH), pre-commit (https://pre-commit.com) is required")
endif

dev: check-pre-commit
	pre-commit install

run:
	go build -o app-bin ./cmd/app && ./app-bin

build:
	go build -ldflags="-X main.Version=$(VERSION)" -o app-bin ./cmd/app

test:
	go test -v ./...

cover:
	go test -cover -v ./...

cover-html:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

lint: check-golangci-lint
	gofumpt -l -w .
	golangci-lint run ./...

update-deps: tidy
	go get -u ./...

tidy:
	go mod tidy

pre-commit: check-pre-commit
	pre-commit run --all-files
