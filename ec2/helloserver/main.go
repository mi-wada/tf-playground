package main

import (
	"context"
	"flag"
	"fmt"
	"html"
	"log"
	"net/http"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

const (
	tableName = "Counts"
	region    = "ap-northeast-1"
)

var port int

func init() {
	flag.IntVar(&port, "port", 8080, "port number of web server")
}

func main() {
	flag.Parse()

	ctx := context.Background()
	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion(region))
	if err != nil {
		log.Fatalf("unable to load SDK config: %v", err)
	}
	dynamodbClient := dynamodb.NewFromConfig(cfg)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Received request: method=%s, path=%s", r.Method, r.URL.Path)
		_, err := dynamodbClient.UpdateItem(
			r.Context(),
			&dynamodb.UpdateItemInput{
				TableName: aws.String(tableName),
				Key: map[string]types.AttributeValue{
					"Id": &types.AttributeValueMemberS{Value: "request"},
				},
				UpdateExpression: aws.String("ADD #count :inc"),
				ExpressionAttributeNames: map[string]string{
					"#count": "count",
				},
				ExpressionAttributeValues: map[string]types.AttributeValue{
					":inc": &types.AttributeValueMemberN{Value: "1"},
				},
				ReturnValues: types.ReturnValueAllNew,
			},
		)
		if err != nil {
			fmt.Fprintf(w, "failed to update dyanmodb: %v", err)
			return
		}
		fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
	})
	log.Printf("Listen on port %d", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), nil))
}
