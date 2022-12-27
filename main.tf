provider "aws" {
  region  = var.region
  profile = "toshi"
}

module "nw" {
  source = "./module/nw"
  vpc_cidr = var.vpc_cidr
  pub_sn_details = var.pub_sn_details
  pvt_sn_details = var.pvt_sn_details
  pub-snet-name = "snet-pb-1"
}

module "sg" {
  source = "./module/sg"
  vpc_id = module.nw.vpc_id
  sg_details = var.sg_details
}

module "role" {
  source = "./module/iam_role"
}

module "eks" {
  source = "./module/eks"
  role_arn = module.role.role-arn
  woker_role_arn = module.role.worker-role-arn
  pub-snet = {
    snet-1 = {
      snet-id = lookup(module.nw.pub_snetid,"snet-pb-1",null)
    },
    snet-2 = {
      snet-id = lookup(module.nw.pub_snetid,"snet-pb-2",null)
    }
  }
  cluster-sg = lookup(module.sg.sg_id,"eks-sg",null)
}
