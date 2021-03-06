TESTRESULTSDIR=$(CURDIR)/test-results/cors
COVERDIR=$(CURDIR)/.cover
COVERAGEFILE=$(COVERDIR)/cover.out
COVERAGEREPORT=$(COVERDIR)/report.html

vet:
	@go vet ./...

fmt:
	@go fmt ./...

test:
	@go test ./...

bench:
	@mkdir -p ./bench-results
	@go test -benchmem -bench=. -cpuprofile ./bench-results/cpu.prof -memprofile ./bench-results/mem.prof
	
plot-cpu:
	@go tool pprof -http :8080 ./bench-results/cpu.prof

plot-mem:
	@go tool pprof -alloc_space -http :8080 ./bench-results/mem.prof

coverage-ci:
	@mkdir -p $(COVERDIR) $(TESTRESULTSDIR)
	@go test -v -covermode=count -coverprofile=$(COVERAGEFILE) 2>&1 | go run github.com/jstemmer/go-junit-report >  $(TESTRESULTSDIR)/report.xml

coverage: coverage-ci
	@cp "${COVERAGEFILE}" coverage.txt

coverage-html: coverage
	@go tool cover -html="$(COVERAGEFILE)"

.PHONY: run build fmt vet test test-watch coverage coverage-ci coverage-html bench plot-cpu plot-mem