locals {
  ssm_tag      = length(data.aws_ssm_parameter.latest_tag) > 0 ? data.aws_ssm_parameter.latest_tag.value : "latest"
  final_tag    = var.manual_image_tag != null ? var.manual_image_tag : local.ssm_tag
}