package main

import (
	"communication/impl"
	"communication/spec"
	"context"
	"log"
	"net/http"

	dapr "github.com/dapr/go-sdk/client"
	"github.com/dapr/go-sdk/service/common"
	daprd "github.com/dapr/go-sdk/service/http"
	"github.com/gorilla/mux"
)

type API struct {
	communicationService spec.CommunicationService
}

var importantSubscription = &common.Subscription{
	PubsubName: "pubsub",
	Topic:      "NewEmployeeCreatedIntegrationEvent",
	Route:      "/important",
	// Match:      `event.type == "important"`,
	Priority: 1,
}

func main() {
	// Set up Dapr client & checks for Dapr sidecar, otherwise die
	daprClient, err := dapr.NewClient()
	if err != nil {
		log.Panicln("FATAL! Dapr process/sidecar NOT found. Terminating!")
	}
	defer daprClient.Close()

	api := API{
		communicationService: impl.Initialize(daprClient),
	}

	router := mux.NewRouter()
	api.addRoutes(router)

	s := daprd.NewServiceWithMux(":5101", router)

	if err := s.AddTopicEventHandler(importantSubscription, importantEventHandler); err != nil {
		log.Fatalf("error adding topic subscription: %v", err)
	}

	if err := s.Start(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("error: %v", err)
	}
}

func importantEventHandler(ctx context.Context, e *common.TopicEvent) (retry bool, err error) {
	log.Printf("important event - PubsubName: %s, Topic: %s, ID: %s, Data: %s", e.PubsubName, e.Topic, e.ID, e.Data)
	return false, nil
}
