provider "aws" {   
    region = "ap-south-1"
}
resource "aws_instance" "newProvisioner" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = aws_key_pair.key-tf.key_name
    vpc_security_group_ids = ["${aws_security_group.newprovisionerSG.id}"]
    tags = var.tags_names

    #connection block used for provisioner
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("${path.module}/id_ed25519")
      host = "${self.public_ip}"
    }
    # 3 types of provisioner--> file,local-exec,remote-exec
    provisioner "file" {
    source = "security.tf"
    destination = "/tmp/security.tf"
    }
    
    #content you provide print the remote server
    provisioner "file" {
      content = "This my content"
      destination = "/tmp/content.md"
    }

    #local-exec print command on your local machine where terraform run & command argument is required for local-exec provisioner
    #1st-->And you can store any information about your server using local-exec you store in file
    #2nd-->jenkins command line job
    #3rd-->you can run any ansible playbook using this local-exec block 
    provisioner "local-exec" {
      command = "echo ${self.public_ip} > /tmp/mypublicip.txt"
    }
    #using workigdir argument you can directe mention where you want to store your file in that directry
    provisioner "local-exec" {
    working_dir = "/tmp/"
      command = "echo ${self.public_ip} > mypublicip.txt"
    }
    #using interpreter argument you can run any script e.g python,etc
    provisioner "local-exec" {
    interpreter = [ 
        "/usr/bin/python3 ","-c"
     ]
      command = "hello world"
    }



}