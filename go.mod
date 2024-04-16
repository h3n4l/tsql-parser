module github.com/bytebase/tsql-parser

go 1.20

require github.com/antlr4-go/antlr/v4 v4.13.0

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

require (
	github.com/stretchr/testify v1.8.4
	golang.org/x/exp v0.0.0-20230515195305-f3d0a9c9a5cc // indirect
)

replace github.com/antlr4-go/antlr/v4 => github.com/h3n4l/antlr/v4 v4.0.0-20231027162627-6c4b67c0e9a1
