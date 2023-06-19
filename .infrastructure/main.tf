provider "aws" {
  region = var.aws_region
}

data "archive_file" "my_first_tf_lambda" {
  type        = "zip"
  source_file = "${path.module}/../src/index.py"
  output_path = "${path.module}/output/lambda.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "my_first_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    }
  }]
}
EOF
}

resource "aws_lambda_function" "my_first_lambda_function" {
  function_name    = "we-did-it-boys"
  filename         = data.archive_file.my_first_tf_lambda.output_path
  handler          = "index.handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = data.archive_file.my_first_tf_lambda.output_base64sha256
}
