#!/bin/bash

set -e

# 1. Running the go test to generate the pprof file.
go test -timeout 600s -run ^TestTSQLParserSingleFilePProf$ github.com/bytebase/tsql-parser

# 2. Using go tool pprof and web to analyze the pprof file.
go tool pprof -http=:9999 cpu.pprof

# 3. Open the browser and go to http://localhost:9999/ui/ to see the pprof result.
