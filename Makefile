.PHONY: dev run test cover cover-html fmt tidy pre-commit

.DEFAULT: help
help:
	@echo "make dev"
	@echo "	setup development environment"
	@echo "make run"
	@echo "	run app"
	@echo "make test"
	@echo "	run go test"
	@echo "make cover"
	@echo "	run go test with -cover"
	@echo "make cover-html"
	@echo "	run go test with -cover and show HTML"
	@echo "make fmt"
	@echo "	run gofumpt"
	@echo "make tidy"
	@echo "	run go mod tidy"
	@echo "make pre-commit"
	@echo "	run pre-commit hooks"

check-gofumpt:
ifeq (, $(shell which gofumpt))
	$(error "gofumpt not in $(PATH), gofumpt (https://pkg.go.dev/mvdan.cc/gofumpt) is required")
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
	go build -o app-bin ./cmd/app

test:
	go test -v ./...

cover:
	go test -cover -v ./...

cover-html:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

fmt: check-gofumpt
	gofumpt -l -w .

tidy:
	go mod tidy

pre-commit: check-pre-commit
	pre-commit run --all-files
