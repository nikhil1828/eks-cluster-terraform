region = "ap-south-1"

vpc_cidr = "10.0.0.0/16"

pub_sn_details = {
    "snet-pb-1" = {
        cidr_block = "10.0.0.0/18"
        availability_zone = "ap-south-1a"
    },
    "snet-pb-2" = {
        cidr_block = "10.0.64.0/18"
        availability_zone = "ap-south-1b"
    }
}

pvt_sn_details = {
    "snet-pvt-1" = {
      cidr_block = "10.0.128.0/18"
      availability_zone = "ap-south-1a"
    },
    "snet-pvt-2" = {
      cidr_block = "10.0.192.0/18"
      availability_zone = "ap-south-1b"
    }
}

sg_details = {
  "eks-sg" = {
    name        = "eks-sg"
    description = "SG for EKS"
    ingress_rules = [
      {
        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        cidr_blocks       = null
        security_groups   = null
        self = true
      },
      {
        from_port         = 30090
        to_port           = 30090
        protocol          = "tcp"
        cidr_blocks       = null
        security_groups   = null
        self = true
      }
    ]
  }
  }