variable "region" {
  description = "The AWS Region that the resources will be provisioned into"
  default = "us-east-1"
}

variable "audit_close_on_delete" {
  description = "Close the Audit Account on Deletion of Stack. Default is FALSE. If False it will remove from the Organization but not close"
  type = bool
  default = false
}

variable "audit_account_friendlyname" {
  description = "The Friendly Name for the Audit Account"
  default = "Audit"
}

variable "audit_account_email" {
  description = "The Email Address for the Audit Account. This is Required and must be unique."
}

variable "logging_close_on_delete" {
  description = "Close the Logging Account on Deletion of Stack. Default is FALSE. If False it will remove from the Organization but not close"
  type = bool
  default = false
}

variable "logging_account_friendlyname" {
  description = "The Friendly Name for the Logging Account"
  default = "Logging"
}

variable "logging_account_email" {
  description = "The Email Address for the Logging Account. This is Required and must be unique."
}

variable "aws_profile" {
  description = "AWS Profile to use where multiple credentials exist in a credential file"
  default = "default"  
}

variable "governed_regions" {
  description = "Control Tower Governed Regions"
  type = list(string)
  default = [
    "us-east-1",
    "us-east-2"
  ]  
}
