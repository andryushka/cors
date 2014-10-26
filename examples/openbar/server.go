package main

import (
	"github.com/rs/cors"
	"net/http"
)

func main() {
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE"},
		AllowCredentials: true,
	})

	h := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte("{\"hello\": \"world\"}"))
	})

	mux := http.NewServeMux()
	mux.Handle("/", c.Handler(h))
	http.ListenAndServe(":8080", mux)
}