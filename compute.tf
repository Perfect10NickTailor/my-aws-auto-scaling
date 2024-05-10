# # Launch Template using existing key pair and security group
# resource "aws_launch_template" "web_server_lt" {
#   name_prefix   = "web-server-lt-"
#   image_id      = var.ami_id
#   instance_type = var.instance_type
#   key_name      = aws_key_pair.my-nick-test-key.key_name

#   block_device_mappings {
#     device_name = "/dev/sda1"
#     ebs {
#       volume_size           = 20
#       volume_type           = "gp2"
#       delete_on_termination = true
#     }
#   }

#   network_interfaces {
#     subnet_id                = aws_subnet.newsubnet.id
#     associate_public_ip_address = true
#     security_groups         = [aws_security_group.asg_security_group.id]
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "WebServer"
#     }
#   }
# }

# # Auto Scaling Group
# resource "aws_autoscaling_group" "web_server_asg" {
#   launch_template {
#     id      = aws_launch_template.web_server_lt.id
#     version = "$Latest"
#   }

#   min_size             = 1
#   max_size             = 10
#   desired_capacity     = 2
#   vpc_zone_identifier  = [aws_subnet.newsubnet.id]
#   health_check_type    = "EC2"
#   health_check_grace_period = 300
#   force_delete         = true
#   wait_for_capacity_timeout = "10m"

#   tag {
#     key                 = "Name"
#     value               = "WebServerInstance"
#     propagate_at_launch = true
#   }
# }
