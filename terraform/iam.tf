# ---------- IAM role for the server (least privilege) ----------
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "server" {
  name               = "${var.project_name}-server-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json

  tags = { Name = "${var.project_name}-server-role" }
}

# AWS-managed policy: lets the CloudWatch agent send logs and metrics
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.server.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Custom policy: read-only access to ONE prefix of ONE bucket
data "aws_iam_policy_document" "app_config_read" {
  statement {
    sid       = "ListAppConfigPrefix"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.state_bucket_name}"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["app-config/*"]
    }
  }

  statement {
    sid       = "ReadAppConfigObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.state_bucket_name}/app-config/*"]
  }
}

resource "aws_iam_role_policy" "app_config_read" {
  name   = "${var.project_name}-app-config-read"
  role   = aws_iam_role.server.id
  policy = data.aws_iam_policy_document.app_config_read.json
}

resource "aws_iam_instance_profile" "server" {
  name = "${var.project_name}-server-profile"
  role = aws_iam_role.server.name
}
