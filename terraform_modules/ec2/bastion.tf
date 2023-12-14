# create a bastion host
resource "aws_instance" "bastion" {
    ami           = "ami-06e4ca05d431835e9"
    instance_type = "t2.micro"
    key_name      = var.key_name
    vpc_security_group_ids = [var.public_instances_sg_id]
    subnet_id     = var.public_subnet_ids[0]
    associate_public_ip_address = true

    tags = {
        Name = "bastion"
    }
}