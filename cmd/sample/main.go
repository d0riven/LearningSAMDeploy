package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(handler)
}

func handler(ctx context.Context, event events.CloudWatchEvent) error {
	fmt.Println("started lambda function")
	fmt.Printf("event: %+v\n", event)
	fmt.Println("stopping lambda function")
	return nil
}
