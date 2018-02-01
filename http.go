package main

import (
  "os"
  "fmt"
  "net/http"
  "log"
  "time"
)

func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    fmt.Fprintf(os.Stdout, "Listening on :%s\n", port)
    hostname, _ := os.Hostname()
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(os.Stdout, "I am %s - %s\n", hostname, time.Now())
        fmt.Fprintf(w, "I am %s - %s\n", hostname, time.Now())
    })


    log.Fatal(http.ListenAndServe(":" + port, nil))
}
