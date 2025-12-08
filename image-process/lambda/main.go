package main

import (
	"context"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	dynatypes "github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

func handleRequest(ctx context.Context, s3Event events.S3Event) error {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Printf("failed to load default config: %s", err)
		return err
	}

	tableName := os.Getenv("DYNAMODB_TABLE")

	s3Client := s3.NewFromConfig(cfg)
	dynamodbClient := dynamodb.NewFromConfig(cfg)
	for _, record := range s3Event.Records {
		bucket := record.S3.Bucket.Name
		key := record.S3.Object.URLDecodedKey
		headOutput, err := s3Client.HeadObject(ctx, &s3.HeadObjectInput{
			Bucket: &bucket,
			Key:    &key,
		})
		if err != nil {
			log.Printf("error getting head of object %s/%s: %s", bucket, key, err)
			return err
		}
		log.Printf("successfully retrieved %s/%s of type %s", bucket, key, *headOutput.ContentType)

		item := map[string]any{
			"Key": key,
		}
		mItem, err := dynatypes.MarshalMap(item)
		if err != nil {
			log.Printf("failed marshal item: %s", err)
			return err
		}

		_, err = dynamodbClient.PutItem(
			ctx,
			&dynamodb.PutItemInput{
				TableName: aws.String(tableName),
				Item:      mItem,
			},
		)
		if err != nil {
			log.Printf("failed to putItem: %s", err)
			return err
		}
	}
	return nil
}

func main() {
	lambda.Start(handleRequest)
}
