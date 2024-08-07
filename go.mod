module github.com/jay/connection-maker

go 1.22.4

require github.com/pyitheinkyaw/vsock v0.0.0-20240805094555-5d09bbc9a8ed

require (
	github.com/joho/godotenv v1.5.1
	golang.org/x/sys v0.23.0
)

// replace github.com/pyitheinkyaw/vsock => ../vsock
