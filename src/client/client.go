package main

import (
	"fmt"
	"log"

	"github.com/pyitheinkyaw/vsock"

	"os"
	"strconv"
)

func clientHandler(cid uint32, port uint32, msg string) {
	serverCID := cid

	fd, err := vsock.Socket()
	if err != nil {
		log.Fatalf("Failed to create socket: %v", err)
	}
	// defer vsock.Close(fd)

	addr := &vsock.SockaddrVM{CID: serverCID, Port: port}
	err = vsock.Connect(fd, addr)
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}

	err = vsock.Send(fd, []byte(msg))
	if err != nil {
		log.Fatalf("Failed to send data: %v", err)
	}
	fmt.Println("Message sent.")
	// defer vsock.Close(fd)
}

func main() {
	// Check if the correct number of arguments is provided
	if len(os.Args) != 4 {
		fmt.Println("Usage: ./client <cid> <port> <message>")
		os.Exit(1)
	}

	// Parse the CID argument
	cid, err := strconv.ParseUint(os.Args[1], 10, 32)
	if err != nil {
		fmt.Printf("Error parsing CID: %v\n", err)
		os.Exit(1)
	}

	// Parse the Port argument
	port, err := strconv.ParseUint(os.Args[2], 10, 32)
	if err != nil {
		fmt.Printf("Error parsing Port: %v\n", err)
		os.Exit(1)
	}

	// Print parsed arguments
	fmt.Printf("client is trying to connect following server information\n")
	fmt.Printf("Server CID: %d\n", cid)
	fmt.Printf("Port: %d\n", port)

	// Call your server handler function with the parsed arguments
	clientHandler(uint32(cid), uint32(port), os.Args[3])
}
