# Create an AWS Organizations Org in the Master Account
# data "aws_organizations_organization" "existing" {}

# locals {
#   org_exists = try(data.aws_organizations_organization.existing.id, null) != null
# }

resource "aws_organizations_organization" "org" {
  #count = local.org_exists ? 0 : 1
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"

  depends_on = [
    aws_iam_role.awscontroltoweradmin_role,
    aws_iam_role.awscontroltowerstackset_role,
    aws_iam_role.awscontroltowercloudtrail_role,
    aws_iam_role.awscontroltowerconfigaggregator_role
  ]
}

# Create the Audit Account
resource "aws_organizations_account" "audit" {
  depends_on = [
    aws_organizations_organization.org,
    aws_iam_role.awscontroltoweradmin_role,
    aws_iam_role.awscontroltowerstackset_role,
    aws_iam_role.awscontroltowercloudtrail_role,
    aws_iam_role.awscontroltowerconfigaggregator_role
  ]
  name              = var.audit_account_friendlyname
  email             = var.audit_account_email
  close_on_deletion = var.audit_close_on_delete
}

# Create the Logging Account
resource "aws_organizations_account" "logging" {
  depends_on = [
    aws_organizations_organization.org,
    aws_iam_role.awscontroltoweradmin_role,
    aws_iam_role.awscontroltowerstackset_role,
    aws_iam_role.awscontroltowercloudtrail_role,
    aws_iam_role.awscontroltowerconfigaggregator_role
  ]
  name              = var.logging_account_friendlyname
  email             = var.logging_account_email
  close_on_deletion = var.logging_close_on_delete
}

# Create the Control Tower Landing Zone
resource "aws_controltower_landing_zone" "example" {
  manifest_json = <<EOF
{
   "governedRegions": ["${join(",", var.governed_regions)}"],
   "organizationStructure": {
       "security": { "name": "Security" },
       "sandbox":  { "name": "IDEC" }
   },
   "centralizedLogging": {
        "accountId": "${aws_organizations_account.logging.id}" ,
        "configurations": {
            "loggingBucket": { "retentionDays": 60 },
            "accessLoggingBucket": { "retentionDays": 60 }
        },
        "enabled": true
   },
   "securityRoles": { "accountId": "${aws_organizations_account.audit.id}" },
   "accessManagement": { "enabled": true }
}
EOF

  version = "3.3"

  depends_on = [
    aws_organizations_account.audit,
    aws_organizations_account.logging,
    aws_iam_role.awscontroltoweradmin_role,
    aws_iam_role.awscontroltowerstackset_role,
    aws_iam_role.awscontroltowercloudtrail_role,
    aws_iam_role.awscontroltowerconfigaggregator_role
  ]
}
