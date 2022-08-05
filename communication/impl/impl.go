package impl

import (
	"communication/configs"
	"context"
	"log"

	dapr "github.com/dapr/go-sdk/client"
)

type CommunicationService struct {
	client dapr.Client
}

func Initialize(client dapr.Client) *CommunicationService {
	return &CommunicationService{
		client: client,
	}
}

func (c *CommunicationService) SendEmail() error {
	log.Default().Println("Sending email !!!")

	if configs.EnableDapr() {
		ctx := context.Background()

		metaData := make(map[string]string)
		metaData["emailFrom"] = "admin@nomail.com"
		metaData["emailTo"] = "nomail@nomail.com"
		metaData["subject"] = "Test send mail by Dapr."

		in := &dapr.InvokeBindingRequest{Name: "sendmail",
			Operation: "create",
			Metadata:  metaData,
			Data:      []byte("hello")}

		if err := c.client.InvokeOutputBinding(ctx, in); err != nil {
			panic(err)
		}
	} else {
		log.Default().Println("Sent email !!!")
	}

	return nil
}
