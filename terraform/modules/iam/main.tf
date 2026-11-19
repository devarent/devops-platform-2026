data "aws_iam_policy_document" "irsa_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "workload" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.irsa_assume.json
  description        = "IRSA role for ${var.namespace}/${var.service_account_name}"

  tags = var.tags
}

# Least-privilege example: read objects from a single illustrative bucket.
# Replace the resource ARN with the ARNs your workload actually needs.
data "aws_iam_policy_document" "workload" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::REPLACE_ME_BUCKET", "arn:aws:s3:::REPLACE_ME_BUCKET/*"]
  }
}

resource "aws_iam_role_policy" "workload" {
  name   = "${var.role_name}-policy"
  role   = aws_iam_role.workload.id
  policy = data.aws_iam_policy_document.workload.json
}
