package main

import (
	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handleRequest(ctx context.Context, _ events.LambdaFunctionURLRequest) (events.LambdaFunctionURLResponse, error) {
	response := events.LambdaFunctionURLResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: `{"message": "Hello from Lambda!"}`,
	}

	return response, nil
}

func main() {
	lambda.Start(handleRequest)
}
