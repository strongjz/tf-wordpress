#--------------------------------------------------------------
# This module creates Cloud trail resources
#--------------------------------------------------------------

variable "cloudtrail_bucket_id" {}
variable "name" {}

resource "aws_cloudtrail" "client-cloudtrail" {
  name                          = "${var.name}-cloudtrail"
  s3_bucket_name                = "${var.cloudtrail_bucket_id}"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}
