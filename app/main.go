package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", HandleRoot)

	fmt.Printf("server started on port %s...\n", port)
	http.ListenAndServe(":"+port, nil)
}

func HandleRoot(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()
	fmt.Fprintf(w, "Hello! This is a Go application running in a container.\n")
	fmt.Fprintf(w, "Server ID: %s\n", hostname)
}