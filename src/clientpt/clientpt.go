package main

import (
	"fmt"
	"log"

	"golang.org/x/sys/unix"
)

const (
	AF_VSOCK    = 40 // Address family for VSOCK sockets
	SOCK_STREAM = 1  // Provides sequenced, reliable, two-way, connection-based byte streams
)

func main() {
	serverCID := uint32(3) // Use the appropriate CID of the server
	port := uint32(8888)   // Port that the server is listening on

	fd, err := unix.Socket(AF_VSOCK, SOCK_STREAM, 0)
	if err != nil {
		log.Fatalf("Failed to create socket: %v", err)
	}
	defer unix.Close(fd)

	sockaddr := &unix.SockaddrVM{
		CID:  serverCID,
		Port: port,
	}

	err = unix.Connect(fd, sockaddr)
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}

	msg := "Hello from client"
	_, err = unix.Write(fd, []byte(msg))
	if err != nil {
		log.Fatalf("Failed to send data: %v", err)
	}

	fmt.Println("Message sent.")
}
