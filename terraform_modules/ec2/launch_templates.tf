data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "private_ecs_lt" {
  name_prefix   = "private-ecs-template-"
  image_id      = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type = "t2.micro"

  key_name               = var.key_name
  vpc_security_group_ids = [var.private_sg_id]
  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "private-ecs-instance"
    }
  }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=uachado-ecs-cluster >> /etc/ecs/ecs.config;
    EOF
  )
}