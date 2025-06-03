data "archive_file" "bot_control_origin_request_edge_code" {
  type        = "zip"
  source_dir  = "../../edge_lambdas/origin_request"
  output_path = "${path.module}/bot_control_origin_request_edge_lambda.zip"
}

resource "aws_lambda_function" "bot_control_origin_request_edge" {
  provider = aws.edge-region

  function_name    = "bot-control-origin-request-edge"
  role             = aws_iam_role.bot_control_origin_request_edge_lambda_execution.arn
  handler          = "lambda.lambda_handler"
  filename         = data.archive_file.bot_control_origin_request_edge_code.output_path
  source_code_hash = filebase64sha256("${data.archive_file.bot_control_origin_request_edge_code.output_path}")
  runtime          = "python3.8"
  publish          = true
}

resource "aws_iam_role" "bot_control_origin_request_edge_lambda_execution" {
  name               = "bot-control-origin-request-edge-lambda-execution"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "edgelambda.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "bot_control_origin_request_edge_lambda_execution_policy" {
  statement {
    sid    = "EdgeLogsAllRegions"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup"
    ]
    # Note: Lambda@Edge creates log groups, streams, and events in the region closest to the user (i.e. the edge)
    resources = ["*"]
  }
  statement {
    sid       = "EdgeGetFunction"
    effect    = "Allow"
    actions   = ["lambda:GetFunction"]
    resources = ["arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:bot-control-origin-request-edge:*"]
  }
  statement {
    sid       = "EdgeFunctionReplication"
    effect    = "Allow"
    actions   = ["lambda:EnableReplication*"]
    resources = ["arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:bot-control-origin-request-edge"]
  }
  statement {
    sid     = "EdgeServiceLinkedRole"
    effect  = "Allow"
    actions = ["iam:CreateServiceLinkedRole"]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/replicator.lambda.amazonaws.com/AWSServiceRoleForLambdaReplicator",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/logger.cloudfront.amazonaws.com/AWSServiceRoleForCloudFrontLogger"
    ]
  }
  statement {
    sid       = "EdgeCloudfrontUpdate"
    effect    = "Allow"
    actions   = ["cloudfront:UpdateDistribution"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "bot_control_origin_request_edge_lambda_execution_policy" {
  name   = "bot-control-origin-request-edge-lambda-execution-policy"
  policy = data.aws_iam_policy_document.bot_control_origin_request_edge_lambda_execution_policy.json
}

resource "aws_iam_role_policy_attachment" "bot_control_origin_request_edge_lambda_execution_policy" {
  role       = aws_iam_role.bot_control_origin_request_edge_lambda_execution.name
  policy_arn = aws_iam_policy.bot_control_origin_request_edge_lambda_execution_policy.arn
}
