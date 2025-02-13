provider "aws" {
  region = "us-east-1"
}

# Create a read-only policy for invoking the Lambda function
resource "aws_iam_policy" "lambda_readonly_policy" {
  name        = "LambdaReadOnlyPolicyJoan"
  description = "Policy that grants read-only access to Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = "*"
      }
    ]
  })
}

# Create a policy to list Lambda functions
resource "aws_iam_policy" "lambda_list_functions_policy" {
  name        = "LambdaListFunctionsPolicyJoan"
  description = "Policy that grants the ability to list Lambda functions"

  # Allow listing of all Lambda functions in the account
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:ListFunctions"
        Resource = "*"
      }
    ]
  })
}

# Create an IAM group
resource "aws_iam_group" "read_only_group" {
  name = "LambdaReadOnlyGroupJoan"
}

# Attach the invoke Lambda policy to the group
resource "aws_iam_group_policy_attachment" "attach_lambda_readonly_policy" {
  group      = aws_iam_group.read_only_group.name
  policy_arn = aws_iam_policy.lambda_readonly_policy.arn
}

# Attach the ListFunctions policy to the group
resource "aws_iam_group_policy_attachment" "attach_lambda_list_functions_policy" {
  group      = aws_iam_group.read_only_group.name
  policy_arn = aws_iam_policy.lambda_list_functions_policy.arn
}

# Create the first user
resource "aws_iam_user" "user1" {
  name = "user1joan"
}

# Create the second user
resource "aws_iam_user" "user2" {
  name = "user2joan"
}

# Add both users to the IAM group
resource "aws_iam_user_group_membership" "user1_group" {
  user  = aws_iam_user.user1.name
  groups = [aws_iam_group.read_only_group.name]
}

resource "aws_iam_user_group_membership" "user2_group" {
  user  = aws_iam_user.user2.name
  groups = [aws_iam_group.read_only_group.name]
}

# Create an administrator user with full access to Lambda
resource "aws_iam_user" "admin_lambda_user" {
  name = "admin-lambda-user-joan"
}

# Create a policy to grant full access to Lambda
resource "aws_iam_policy" "lambda_full_access_policy" {
  name        = "LambdaFullAccessPolicyJoan"
  description = "Policy that grants full access to AWS Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:*"
        Resource = "*"
      }
    ]
  })
}

# Attach the full access Lambda policy to the admin user
resource "aws_iam_user_policy_attachment" "attach_lambda_full_access_policy" {
  user       = aws_iam_user.admin_lambda_user.name
  policy_arn = aws_iam_policy.lambda_full_access_policy.arn
}


# Create the IAM role for Lambda use case
resource "aws_iam_role" "lambda_role" {
  name               = "LambdaUseCaseRoleJoan"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the same policies to the Lambda role
resource "aws_iam_role_policy_attachment" "attach_lambda_readonly_policy_to_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_readonly_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_lambda_list_functions_policy_to_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_list_functions_policy.arn
}

