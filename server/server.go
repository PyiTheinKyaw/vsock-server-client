package main

import (
	"fmt"
	"log"

	"github.com/pyitheinkyaw/vsock"

	"os"
	"strconv"
)

func serverHandler(port uint32) {

	fd, err := vsock.Socket()
	if err != nil {
		log.Fatalf("Failed to create socket: %v", err)
	}
	defer vsock.Close(fd)

	addr := &vsock.SockaddrVM{CID: vsock.VMADDR_CID_ANY, Port: port}
	err = vsock.Bind(fd, addr)
	if err != nil {
		log.Fatalf("Failed to bind socket: %v", err)
	}

	err = vsock.Listen(fd, 32)
	if err != nil {
		log.Fatalf("Failed to listen on socket: %v", err)
	}

	contextId, ctx_err := vsock.ContextID()
	if ctx_err != nil {
		log.Fatalf("[Server-Context]: %v", ctx_err)
	}

	log.Println("Server is listeing on port:", port, "with CID:", contextId)

	for {
		nfd, _, err := vsock.Accept(fd)
		if err != nil {
			log.Printf("Failed to accept connection: %v", err)
			continue
		}
		go handleConnection(nfd)
	}
}

func handleConnection(fd int) {
	defer vsock.Close(fd)
	for {
		buf, err := vsock.Recv(fd)
		if err != nil {
			log.Printf("Failed to read from socket: %v", err)
			return
		}
		if len(buf) == 0 {
			break
		}
		fmt.Printf("Received: %s\n", string(buf))
	}
}

func main() {
	// Check if the correct number of arguments is provided
	if len(os.Args) != 2 {
		fmt.Println("Usage: ./server <port>")
		os.Exit(1)
	}

	// Parse the Port argument
	port, err := strconv.ParseUint(os.Args[1], 10, 32)
	if err != nil {
		fmt.Printf("Error parsing Port: %v\n", err)
		os.Exit(1)
	}

	// Call your server handler function with the parsed arguments
	serverHandler(uint32(port))
}
