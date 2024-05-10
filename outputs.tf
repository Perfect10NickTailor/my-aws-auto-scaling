output "vpc_id" {
  value = aws_vpc.vpc2.id
  description = "The ID of the VPC created."
}

output "subnet_id" {
  value = aws_subnet.newsubnet.id
  description = "The ID of the subnet created."
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.web_server_asg.id
  description = "The ID of the Auto Scaling Group."
}
