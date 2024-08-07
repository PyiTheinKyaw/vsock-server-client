# Names of the Go binaries
BINARY_NAME_SERVER=server
BINARY_NAME_SERVER-PT=serverpt
BINARY_NAME_CLIENT=client
BINARY_NAME_CLIENT-PT=clientpt
CURRENT_DIR := $(shell pwd)

# Default target
all: build

# Build the Go binary for SERVER
build-server:
	@echo "Building the Go binary for server..."
	go build -o $(CURRENT_DIR)/bin/$(BINARY_NAME_SERVER) ./src/server

build-server-pt:
	@echo "Building Portalbe server directly using golang.org/x/sys/unix"
	go build -o $(CURRENT_DIR)/bin/$(BINARY_NAME_SERVER_PT) ./src/serverpt

# Build the Go binary for Client
build-client:
	@echo "Building the Go binary for client..."
	go build -o $(CURRENT_DIR)/bin/$(BINARY_NAME_CLIENT) ./src/client

build-client-pt:
	@echo "Building Portalbe client directly using golang.org/x/sys/unix"
	go build -o $(CURRENT_DIR)/bin/$(BINARY_NAME_CLIENT_PT) ./src/clientpt

clean:
	@echo "Clean bin folder"
	rm -rf bin/*

# Build both applications
build: build-server build-server-pt build-client build-client-pt

# Run server
run-server: build-server
	@echo "Running the server"
	./$(BINARY_NAME_SERVER) 1 1

# Run server
run-client: build-client
	@echo "Running the client"
	./$(BINARY_NAME_SERVER) 1

# Check for dependencies
mod-tidy:
	@echo "Tidying up Go modules..."
	go mod tidy

# Print help message
help:
	@echo "Makefile targets:"
	@echo "  all      - Build both Go binaries (default target)"
	@echo "  build    - Build both Go binaries"
	@echo "  build-server - Build Server"
	@echo "  build-client - Build Client"
	@echo "  mod-tidy - Tidy up Go modules"

.PHONY: all build build-server build-client mod-tidy
