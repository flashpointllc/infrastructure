package main

import (
    "net/http"
    "time"
    "log"
    "os"
)


var path string = os.Getenv("HEALTHCHECK_PATH")
var port string = ":" + os.Getenv("HEALTHCHECK_PORT")

func main() {
    srv := &http.Server{
        Addr:         port,
        ReadTimeout:  2 * time.Second,
        WriteTimeout: 2 * time.Second,
        IdleTimeout:  2 * time.Second,
        Handler:      http.HandlerFunc(httpHandler),
    }

    log.Fatal(srv.ListenAndServe())
}

func httpHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method == "OPTIONS" {
        return
    }

    // Load Balancer Health Check
    if r.URL.Path == path {
        w.Header().Set("Content-Type", "text/plain")
        w.Write([]byte("OK"))
        return
    }
}
