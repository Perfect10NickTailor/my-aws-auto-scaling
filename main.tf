# Provider Configuration
provider "aws" {
  region = "us-west-2"
}


# Create a VPC
resource "aws_vpc" "vpc2" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet within the VPC
resource "aws_subnet" "newsubnet" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

# Define your security group
resource "aws_security_group" "asg_security_group" {
  name        = "web-server-security-group"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.vpc2.id  # Ensure association with the correct VPC

  # Define your security group rules here
  # Example rule: allow incoming HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Example rule: allow incoming SSH traffic from a specific IP range
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Define egress rules if needed
  # Example rule: allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a key pair
resource "aws_key_pair" "my-nick-test-key" {
  key_name   = "my-nick-test-key"
  public_key = file("${path.module}/terraform-aws-key.pub")
}

# Launch Template using existing key pair and security group
resource "aws_launch_template" "web_server_lt" {
  name_prefix   = "web-server-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.my-nick-test-key.key_name

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  network_interfaces {
    subnet_id                = aws_subnet.newsubnet.id
    associate_public_ip_address = true
    security_groups         = [aws_security_group.asg_security_group.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebServer"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web_server_asg" {
  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"
  }

  min_size             = 1
  max_size             = 10
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.newsubnet.id]
  health_check_type    = "EC2"
  health_check_grace_period = 300
  force_delete         = true
  wait_for_capacity_timeout = "10m"

  tag {
    key                 = "Name"
    value               = "WebServerInstance"
    propagate_at_launch = true
  }
}

# Scaling Policy
resource "aws_autoscaling_policy" "web_server_scaling_policy" {
  name                   = "cpu-utilization"
  autoscaling_group_name = aws_autoscaling_group.web_server_asg.id
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 180  # 3 minutes warm-up period

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50  # Target CPU utilization percentage
  }
}
