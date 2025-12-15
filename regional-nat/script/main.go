package main

import (
	"context"
	"io"
	"net/http"

	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context) (string, error) {
	req, err := http.NewRequest(http.MethodGet, "https://ifconfig.me", nil)
	if err != nil {
		panic(err)
	}
	req.Header.Add("Accept", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	b, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return string(b), nil
}

func main() {
	lambda.Start(handler)
}
