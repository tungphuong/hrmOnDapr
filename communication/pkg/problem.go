package pkg

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

// Problem in RFC-7807 format
type Problem struct {
	Type     string `json:"type"`
	Title    string `json:"title"`
	Status   int    `json:"status,omitempty"`
	Detail   string `json:"detail,omitempty"`
	Instance string `json:"instance,omitempty"`
}

func New(url, title string, status int, detail, instance string) *Problem {
	return &Problem{url, title, status, detail, instance}
}

func (p *Problem) Send(resp http.ResponseWriter) {
	log.Printf("### API %s", p.Error())
	resp.Header().Set("Content-Type", "application/json")
	resp.WriteHeader(p.Status)
	json.NewEncoder(resp).Encode(p)
}

// Implement error interface
func (p Problem) Error() string {
	return fmt.Sprintf("Problem: Type: '%s', Title: '%s', Status: '%d', Detail: '%s', Instance: '%s'", p.Type, p.Title, p.Status, p.Detail, p.Instance)
}
