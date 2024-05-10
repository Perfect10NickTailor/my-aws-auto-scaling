# # Define your security group
# resource "aws_security_group" "asg_security_group" {
#   name        = "web-server-security-group"
#   description = "Security group for web servers"
  
#   # Define your security group rules here
#   # Example rule: allow incoming HTTP traffic
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Example rule: allow incoming SSH traffic from a specific IP range
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   # Define egress rules if needed
#   # Example rule: allow all outgoing traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }