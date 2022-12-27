# creating vpc output
output "vpc_id"{
    value = aws_vpc.eks_vpc.id
} 
 
 output "pub_snetid" {
    # value = aws_subnet.pub-snet
    value = {for k, v in aws_subnet.pub-snet:k=>v.id}
}

#  output "pvt_snetid" {
#     value = aws_subnet.pri-snet
# }

# output "pvt_snetid-2" {
#   value = {for k, v in aws_subnet.pri-snet:k=>v.id}
# }