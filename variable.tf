variable "region" {}

variable "vpc_cidr" {}

variable "pub_sn_details" {}

variable "pvt_sn_details" {}

variable "sg_details" {
  type = map(object({
    name        = string
    description = string
    ingress_rules = list(object({
      from_port         = number
      to_port           = number
      protocol          = string
      cidr_blocks       = list(string)
      self              = bool
      security_groups   = list(string)
    }))
  }))
  default = {}
}