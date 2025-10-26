# Create the Control Tower Required IAM Roles

resource "aws_iam_role" "awscontroltoweradmin_role" {
  path = "/service-role/"
  name = "AWSControlTowerAdmin"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "controltower.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "awscontroltoweradmin_inline_policy" {
  name = "AWSControlTowerAdminPolicy"
  role = aws_iam_role.awscontroltoweradmin_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeAvailabilityZones",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "awscontroltoweradmin_managedpolicy" {
  role       = aws_iam_role.awscontroltoweradmin_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSControlTowerServiceRolePolicy"
  
}

# Create the CloudFormation StackSet Role

resource "aws_iam_role" "awscontroltowerstackset_role" {
  path = "/service-role/"
  name = "AWSControlTowerStackSetRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    
    
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudformation.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "awscontroltowerstackset_inline_policy" {
  name = "AWSControlTowerStacksetPolicy"
  role = aws_iam_role.awscontroltowerstackset_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
    
        "Effect": "Allow",
        "Resource": [
                  "arn:aws:iam::*:role/AWSControlTowerExecution"
          ],
        "Action": "sts:AssumeRole"
      }

    ]
  })
}

resource "aws_iam_role" "awscontroltowercloudtrail_role" {
  name = "AWSControlTowerCloudTrailRole"
  path = "/service-role/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "awscontroltowercloudtrail_inline_policy" {
  name = "AWSControlTowerCloudTrailPolicy"
  role = aws_iam_role.awscontroltowercloudtrail_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Resource": [
                  "arn:aws:iam::*:role/AWSControlTowerExecution"
          ],
        "Action": "sts:AssumeRole"
      },
       {
            "Action": "logs:CreateLogStream",
            "Resource": "arn:aws:logs:*:*:log-group:aws-controltower/CloudTrailLogs:*",
            "Effect": "Allow"
        },
        {
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:*:*:log-group:aws-controltower/CloudTrailLogs:*",
            "Effect": "Allow"
        }
    ]
  })
}


resource "aws_iam_role" "awscontroltowerconfigaggregator_role" {
  name = "AWSControlTowerConfigAggregatorRoleForOrganizations"
  path = "/service-role/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "awscontroltowerconfigrole_inline_policy" {
  name = "AWSControlTowerConfigAggregatorPolicy"
  role = aws_iam_role.awscontroltowerconfigaggregator_role.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
      "Effect": "Allow",
      "Resource": [
                "arn:aws:iam::*:role/AWSControlTowerExecution"
        ],
      "Action": "sts:AssumeRole"
    },
      {
        "Effect": "Allow",
        "Action": [
          "organizations:ListAccounts",
          "organizations:DescribeOrganization",
          "organizations:ListAWSServiceAccessForOrganization"
         ],
       "Resource": "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "awscontroltowerconfigrole_managedpolicy" {
  role       = aws_iam_role.awscontroltowerconfigaggregator_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
  
}