.PHONY: dev audit coverage coverage-html format lint pre-commit run test tidy update-dependencies

.DEFAULT: help
help:
	@echo "make dev"
	@echo "	setup development environment"
	@echo "make audit"
	@echo "	conduct quality checks"
	@echo "make coverage"
	@echo "	generate coverage report"
	@echo "make coverage-html"
	@echo "	generate coverage HTML report"
	@echo "make format"
	@echo "	fix code format issues"
	@echo "make lint"
	@echo "	run lint checks"
	@echo "make pre-commit"
	@echo "	run pre-commit hooks"
	@echo "make run"
	@echo "	run application"
	@echo "make test"
	@echo "	execute all tests"
	@echo "make tidy"
	@echo "	clean and tidy dependencies"
	@echo "make update-dependencies"
	@echo "	update dependencies"

GOTESTSUM := go run gotest.tools/gotestsum@latest -f testname -- ./... -race -count=1
TESTFLAGS := -shuffle=on
COVERFLAGS := -covermode=atomic
GOLANGCI_LINT := go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.0.2

check-pre-commit:
ifeq (, $(shell which pre-commit))
	$(error "pre-commit not in $(PATH), pre-commit (https://pre-commit.com) is required")
endif

dev: check-pre-commit
	pre-commit install

audit:
	go mod verify
	go run golang.org/x/vuln/cmd/govulncheck@latest ./...

coverage:
	$(GOTESTSUM) $(TESTFLAGS) $(COVERFLAGS)

coverage-html:
	$(GOTESTSUM) $(TESTFLAGS) $(COVERFLAGS) -coverprofile=coverage.out
	go tool cover -html=coverage.out

format:
	$(GOLANGCI_LINT) fmt

lint:
	$(GOLANGCI_LINT) run

pre-commit: check-pre-commit
	pre-commit run --all-files

run:
	go build -o app-bin ./cmd/app && ./app-bin

test:
	$(GOTESTSUM) $(TESTFLAGS)

tidy:
	go mod tidy -v

update-dependencies: tidy
	go get -u ./...
