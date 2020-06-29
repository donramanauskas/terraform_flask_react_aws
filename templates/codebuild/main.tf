resource "aws_iam_role" "codebuild_project_role" {
  name               = "role_for_running_codebuild_projects"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_codebuild_project" "flask_react_codebuild_demo" {

  name = "flask_react_codebuild_project"
  service_role = aws_iam_role.codebuild_project_role.name
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:2.0"
    type = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name = "AWS_ACCOUNT_ID"
      value = var.account_id
    }

    environment_variable {
      name = "LOAD_BALANCER_DNS_NAME"
      value = var.dns_name
    }

    environment_variable {
      name = "AWS_RDS_URI"
      value = var.rds_uri
    }

    environment_variable {
      name = "PRODUCTION_SECRET_KEY"
      value = var.production_secret_key
    }
  }

  source {
    type = "GITHUB"
    location = var.project_location
  }

}

resource "aws_codebuild_webhook" "codebuild_webhook" {
  project_name = aws_codebuild_project.flask_react_codebuild_demo.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "master"
    }
  }
}

data "aws_iam_policy_document" "codebuild_allow_cloudwatch_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "codebuild_allow_cloudwatch_policy" {
  policy = data.aws_iam_policy_document.codebuild_allow_cloudwatch_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild_allow_cloudwatch" {
  policy_arn = aws_iam_policy.codebuild_allow_cloudwatch_policy.arn
  role       = aws_iam_role.codebuild_project_role.name
}

resource "aws_iam_role_policy_attachment" "codebuild_allow_ecr" {
  role = aws_iam_role.codebuild_project_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}