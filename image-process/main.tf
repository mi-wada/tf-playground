locals {
  function_name = "record_metadata"
  table_name    = "images"
}

resource "aws_dynamodb_table" "images" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Key"
  attribute {
    name = "Key"
    type = "S"
  }
}

resource "aws_s3_bucket" "image" {
  bucket_prefix = "image"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "image" {
  bucket = aws_s3_bucket.image.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.record_metadata.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".png"
  }
  lambda_function {
    lambda_function_arn = aws_lambda_function.record_metadata.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }
  lambda_function {
    lambda_function_arn = aws_lambda_function.record_metadata.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpeg"
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}

resource "aws_lambda_function" "record_metadata" {
  function_name    = local.function_name
  filename         = data.archive_file.record_metadata.output_path
  source_code_hash = data.archive_file.record_metadata.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  publish          = true
  environment {
    variables = {
      DYNAMODB_TABLE = local.table_name
    }
  }
}

data "archive_file" "record_metadata" {
  type        = "zip"
  source_file = "${path.module}/lambda/build/bootstrap"
  output_path = "${path.module}/lambda/build/bootstrap.zip"
}

# Lambdaにアタッチする、LambdaからS3へのアクセスを許可するIAM Role
resource "aws_iam_role" "lambda_exec" {
  name               = "${local.function_name}-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${local.function_name}-policy"
  role   = aws_iam_role.lambda_exec.name
  policy = data.aws_iam_policy_document.lambda_policy.json
}
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:HeadObject"
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.image.bucket}/*"]
  }
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [aws_dynamodb_table.images.arn]
  }
}

# S3がLambdaを呼び出すのを許可
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.record_metadata.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.image.arn
}
