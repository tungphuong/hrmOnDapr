package main

import (
	"communication/pkg"
	"net/http"

	"github.com/gorilla/mux"
)

func (api API) addRoutes(router *mux.Router) {
	router.HandleFunc("/email", api.sendEmail).Methods("POST")
}

func (api API) sendEmail(resp http.ResponseWriter, req *http.Request) {
	err := api.communicationService.SendEmail()

	if err != nil {
		prob := err.(*pkg.Problem)
		prob.Send(resp)
		return
	}

	resp.Header().Set("Content-Type", "application/json")
	resp.WriteHeader(http.StatusOK)
}
