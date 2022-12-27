//decleration of vpc
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name ="${terraform.workspace}_vpc"
    env = "${terraform.workspace}"
  }
}


resource "aws_subnet" "pub-snet" {
    for_each = var.pub_sn_details
    vpc_id     = aws_vpc.eks_vpc.id 
    cidr_block = each.value["cidr_block"]
    availability_zone = each.value["availability_zone"]
    map_public_ip_on_launch = true

  tags = {
    Name ="${terraform.workspace}_pub_snet"
    env = "${terraform.workspace}"
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "pri-snet" {
 for_each = var.pvt_sn_details
 vpc_id = aws_vpc.eks_vpc.id
 cidr_block = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]
 
  tags= {
  Name ="${terraform.workspace}_pvt_snet"
  env = "${terraform.workspace}"
  "kubernetes.io/cluster/eks-cluster" = "shared"
  "kubernetes.io/role/elb" = "1"
 }
}

# creating igw for pub snet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${terraform.workspace}_vpc_igw"
    env = "${terraform.workspace}"  
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.eks_vpc.id

    route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
   }

   tags = {
   Name = "${terraform.workspace}_vpc_pub_rt"
   env = "${terraform.workspace}"
   }
 }

resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
  Name = "${terraform.workspace}_vpc_pvt_rt"
  env = "${terraform.workspace}"
  }
 }

resource "aws_route_table_association" "pbsnet_assoc" {
 for_each = aws_subnet.pub-snet
 subnet_id   = each.value.id
 route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pvtsnet_assoc" {
 for_each = aws_subnet.pri-snet
 subnet_id   = each.value.id
 route_table_id = aws_route_table.pvt_rt.id
}