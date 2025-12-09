package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

func handler(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()
	currentTime := time.Now().Format("2006-01-02 15:04:05")
	
	response := fmt.Sprintf(`
	<!DOCTYPE html>
	<html>
	<head>
		<title>Go Web Server</title>
		<style>
			body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; }
			.info { background: #f0f0f0; padding: 15px; border-radius: 5px; }
		</style>
	</head>
	<body>
		<h1>🐳 Hello from Docker!</h1>
		<div class="info">
			<p><strong>Hostname:</strong> %s</p>
			<p><strong>Time:</strong> %s</p>
			<p><strong>Request Path:</strong> %s</p>
		</div>
		<p>This Go application is built using multi-stage Docker build.</p>
	</body>
	</html>
	`, hostname, currentTime, r.URL.Path)
	
	fmt.Fprint(w, response)
	log.Printf("Request from %s to %s", r.RemoteAddr, r.URL.Path)
}

func main() {
	http.HandleFunc("/", handler)
	
	port := ":8080"
	fmt.Printf("🚀 Server starting on http://0.0.0.0%s\n", port)
	fmt.Println("📝 Press Ctrl+C to stop")
	
	if err := http.ListenAndServe(port, nil); err != nil {
		log.Fatal(err)
	}
}
