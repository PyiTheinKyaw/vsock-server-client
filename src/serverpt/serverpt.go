package main

import (
	"fmt"
	"log"

	"golang.org/x/sys/unix"
)

const (
	AF_VSOCK       = 40         // Address family for VSOCK sockets
	SOCK_STREAM    = 1          // Provides sequenced, reliable, two-way, connection-based byte streams
	VMADDR_CID_ANY = 0xFFFFFFFF // Bind to any CID
	HOST           = 0x2
)

func main() {
	port := uint32(8888) // Port to listen on

	fd, err := unix.Socket(unix.AF_VSOCK, unix.SOCK_STREAM, 0)
	if err != nil {
		log.Fatalf("Failed to create socket: %v", err)
	}

	sockaddr := &unix.SockaddrVM{
		CID:  unix.VMADDR_CID_ANY,
		Port: port,
	}
	err = unix.Bind(fd, sockaddr)
	if err != nil {
		log.Fatalf("Failed to bind socket: %v", err)
	}

	err = unix.Listen(fd, 10)
	if err != nil {
		log.Fatalf("Failed to listen on socket: %v", err)
	}

	defer unix.Close(fd)

	log.Println("Server is listening...")

	for {

		nfd, _, err := unix.Accept(fd)

		if err != nil {
			log.Printf("Failed to accept connection: %v", err)
			continue
		}

		go handleConnection(nfd)
	}
}

func handleConnection(fd int) {
	defer unix.Close(fd)
	log.Println(fd)
	for {
		buf := make([]byte, 1024)
		n, err := unix.Read(fd, buf)
		if err != nil {
			log.Printf("Failed to read from socket: %v", err)
			return
		}
		if n == 0 {
			break
		}
		fmt.Printf("Received: %s\n", string(buf[:n]))
	}
}
