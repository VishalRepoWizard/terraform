provider "aws" {   
    region = "ap-south-1"
}
resource "aws_instance" "myproject" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = ["sg-03eb9c454196b950d"]
    tags = var.tags_names
}