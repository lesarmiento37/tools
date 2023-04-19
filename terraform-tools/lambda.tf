data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "auth_user_habytat" {
  statement {
    sid    = "AllowPullDockerImageSmartVerse"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "iam:PassRole",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:AttachNetworkInterface",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "auth_user_habytat" {
  name               = "iam_auth_user_habytat"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "auth_user_habytat" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function.zip"
  function_name = "auth_user_habytat"
  role          = aws_iam_role.auth_user_habytat.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs16.x"

  environment {
    variables = {
      foo = "bar"
      DB_HOST = replace(jsonencode(local.my_secret_object.DB_HOST), "\"", "")
      INITIAL_COINTS = local.my_global_variables.INITIAL_COINTS
    }
  }

  vpc_config {
    security_group_ids = ["sg-08cefba26ace0c75e"]
    subnet_ids         = ["subnet-0374cbcc093103c7c","subnet-090ec5d98da232b0d"]
  }
}
resource "aws_iam_policy" "auth_user_habytat" {
  name        = "lambda_auth_user_habytat"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.auth_user_habytat.json
}

resource "aws_iam_role_policy_attachment" "auth_user_habytat" {
  role       = aws_iam_role.auth_user_habytat.name
  policy_arn = aws_iam_policy.auth_user_habytat.arn
}
