resource "aws_iam_role" "lambda_role" {
  name = "Key_Rotation_Lambda_Role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  version = "2012-10-17"

  statement {
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "KeyRotationLambdaPolicy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

data "aws_iam_policy_document" "lambda_policy" {
  version = "2012-10-17"

  statement {
    actions   = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys",
      "iam:ListUsers",
      "ssm:PutParameter",
      "ssm:GetParameter",
      "ssm:DeleteParameter",
      "ssm:ListParameters"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role" "eventbridge" {
  name = "Key_Rotation_EventBridge_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      }
    ]
  })
}



resource "aws_iam_role_policy" "eventbridge_policy" {
  name   = "Key_Rotation_EventBridge_Policy"
  role   = aws_iam_role.eventbridge.id
  policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "lambda:InvokeFunction"
        ],
        Resource = aws_lambda_function.key_rotation.arn
      }
    ]
  })
}
