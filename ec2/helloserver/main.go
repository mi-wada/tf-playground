package main

import (
	"flag"
	"fmt"
	"html"
	"log"
	"net/http"
)

var port int

func init() {
	flag.IntVar(&port, "port", 8080, "port number of web server")
}

func main() {
	flag.Parse()
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Received request: method=%s, path=%s", r.Method, r.URL.Path)
		fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
	})
	log.Printf("Listen on port %d", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), nil))
}
