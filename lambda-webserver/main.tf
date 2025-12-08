locals {
  function_name = "record_metadata"
}

resource "aws_lambda_function" "record_metadata" {
  function_name    = local.function_name
  filename         = data.archive_file.record_metadata.output_path
  source_code_hash = data.archive_file.record_metadata.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  publish          = true
}

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

data "archive_file" "record_metadata" {
  type        = "zip"
  source_file = "${path.module}/lambda/build/bootstrap"
  output_path = "${path.module}/lambda/build/bootstrap.zip"
}

resource "aws_lambda_function_url" "public" {
  function_name      = aws_lambda_function.record_metadata.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "allow_function_url" {
  statement_id           = "AllowFunctionURLInvoke"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.record_metadata.function_name
  principal              = "*"
  function_url_auth_type = aws_lambda_function_url.public.authorization_type
}

output "function_url" {
  value = aws_lambda_function_url.public.function_url
}
