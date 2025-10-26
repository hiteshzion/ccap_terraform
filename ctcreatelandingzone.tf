# Create an AWS Organizations Org in the Master Account
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"
}

# Create the Audit Account

resource "aws_organizations_account" "audit" {
  depends_on = [ aws_organizations_organization.org ]
  name  = "${var.audit_account_friendlyname}"
  email = "${var.audit_account_email}"
  close_on_deletion = "${var.audit_close_on_delete}"
}

# Create the Logging Account

resource "aws_organizations_account" "logging" {
  depends_on = [ aws_organizations_organization.org ]
  name  = "${var.logging_account_friendlyname}"
  email = "${var.logging_account_email}"
  close_on_deletion = "${var.logging_close_on_delete}"
}


# Create the Backup Account

#resource "aws_organizations_account" "backup" {
#  name  = "${var.backup_account_friendlyname}"
#  email = "${var.backup_account_email}"
#  close_on_deletion = "${var.backup_close_on_delete}"
#}



resource "aws_controltower_landing_zone" "example" {
  manifest_json = <<EOF
{
   "governedRegions": ["${join(",", var.governed_regions)}"],
   "organizationStructure": {
       "security": {
           "name": "CORE"
       },
       "sandbox": {
           "name": "Sandbox"
       }
   },
   "centralizedLogging": {
        "accountId": "${aws_organizations_account.logging.id}" ,
        "configurations": {
            "loggingBucket": {
                "retentionDays": 60
            },
            "accessLoggingBucket": {
                "retentionDays": 60
            }
            
        },
        "enabled": true
   },
   "securityRoles": {
        "accountId": "${aws_organizations_account.audit.id}"
   },
   "accessManagement": {
        "enabled": true
   }
}
EOF
  version       = "3.3"
}