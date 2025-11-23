resource "aws_dynamodb_table" "count" {
  name         = "Counts"
  hash_key     = "Id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Id"
    type = "S"
  }
}
