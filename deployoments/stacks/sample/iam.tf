resource "aws_iam_user" "deploy_sam_ci_sample" {
  name = "deploy-sam-ci-sample"
  path = "/"
}

resource "aws_iam_user_policy" "deploy_sam_ci_sample" {
  name   = "AllowSamDeploy"
  user   = aws_iam_user.deploy_sam_ci_sample.name
  policy = data.aws_iam_policy_document.deploy_sam_ci_sample_deploy.json
}

data "aws_iam_policy_document" "deploy_sam_ci_sample_deploy" {
  statement {
    sid = "SamDeploy"
    actions = [
      "cloudformation:Describe*",
      "cloudformation:Get*",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:Create*",
      "cloudformation:Update*",
    ]
    resources = ["*"]
  }

  statement {
    sid = "SAMValidate"
    actions = [
      "iam:ListPolicies",
    ]
    resources = ["*"]
  }

  statement {
    sid = "SAMPackage"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::doriven-lambda-artifacts/learning-sam-ci-deploy/sample/*",
    ]
  }

  statement {
    actions = [
      "s3:Get*",
      "iam:List*",
      "iam:*Role*",
      "events:*",
      "lambda:*",
      "logs:*",
    ]
    resources = ["*"]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["cloudformation.amazonaws.com"]
    }
  }
}
