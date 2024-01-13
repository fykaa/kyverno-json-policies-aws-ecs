# resource "aws_key_pair" "deployer" {
#   key_name   = "tempkey"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgRCn1XNy6HdJe3zbiGhykGWFtmPWDMz8EgnDF02RWDCfU5M5qM7mAK+NNHp0pTYIuivJVsOZ974AN50nsl1l6M++Kz6t6evbvk3YAL00kOFlTFSzR0xopFddV/gbYsFktlPxIGrNbdTwBzuRIcQTDaKmhatJ7WOYf0qnuPqRrqQ89TqV3LizmHzbOd3tVmNdL2+blB+JDMy83BMQjTzIRzuCIPSf0EJIraGwLcuxhfuaeOyq/yzP8bM8gGi/Uizx2D+5TRqSSN0g2QozJbMxoOgEWg7MdWwTwwGb44HH8Q2Yg1Hkpk7WlrNoxg4ZsJqdnGNVJS9Ty5fJHhJqQ1DYr"
# }

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "ecs-template"
  image_id      = "ami-01d83f77e6a272e35" # NECESSARY. The AMI serves as the foundation for an EC2 instance. It includes the operating system, software, and any configurations you want on the instance. Without a specified AMI, Terraform doesn't know what image to use when launching the EC2 instances. Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"

  # key_name               = "tempkey"
  vpc_security_group_ids = [aws_security_group.sg.id]
  # Specifies the IAM instance profile to associate with the EC2 instances. In this example, it is set to "ecsInstanceRole"
  # Need to Make sure IAM instance profile (ecsInstanceRole) are defined elsewhere in your Terraform configuration
  iam_instance_profile {
    name = "ecsInstanceRole"
  }

# defines how storage is configured for the instance, like volume size and type
  # block_device_mappings {
  #   device_name = "/dev/xvda"
  #   ebs {
  #     volume_size = 30
  #     volume_type = "gp2"
  #   }
  # }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("${path.module}/ecs.sh")
}

#  If you're running a basic EC2 instance without the need for automatic scaling, you may not need the aws_autoscaling_group resource.
# resource "aws_autoscaling_group" "ecs_asg" {
#   vpc_zone_identifier = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
#   desired_capacity    = 2
#   max_size            = 3
#   min_size            = 1

#   launch_template {
#     id      = aws_launch_template.ecs_lt.id
#     version = "$Latest"
#   }

#   tag {
#     key                 = "AmazonECSManaged"
#     value               = true
#     propagate_at_launch = true
#   }
# }

//Alb
# resource "aws_lb" "ecs_alb" {
#   name               = "ecs-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.security_group.id]
#   subnets            = [aws_subnet.subnet.id, aws_subnet.subnet2.id]

#   tags = {
#     Name = "ecs-alb"
#   }
# }

# resource "aws_lb_listener" "ecs_alb_listener" {
#   load_balancer_arn = aws_lb.ecs_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.ecs_tg.arn
#   }
# }

# Target groups are primarily associated with load balancers, such as AWS Application Load Balancer (ALB) or Network Load Balancer (NLB). If you're not using a load balancer, creating a target group may not be necessary.
# resource "aws_lb_target_group" "ecs_tg" {
#   name        = "ecs-target-group"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = aws_vpc.main.id

#   health_check {
#     path = "/"
#   }
# }

resource "aws_instance" "ecs_instance" {
  ami                    = aws_launch_template.ecs_lt.image_id
  instance_type          = aws_launch_template.ecs_lt.instance_type
  key_name               = aws_launch_template.ecs_lt.key_name
  vpc_security_group_ids = aws_launch_template.ecs_lt.vpc_security_group_ids

  # Other necessary configurations based on your use case
  subnet_id              = aws_subnet.subnet.id
  iam_instance_profile   = aws_launch_template.ecs_lt.iam_instance_profile[0].name
  user_data              = aws_launch_template.ecs_lt.user_data
  tags = {
    Name = aws_launch_template.ecs_lt.tag_specifications[0].tags.Name
  }
}

output "ecs_configuration_script" {
  value = aws_instance.ecs_instance.user_data # Assuming user_data contains the content of ecs.sh
}
