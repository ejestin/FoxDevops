################################################ TERRAFORM ################################################
# Provides 1 + <count> Latest EC2 VMs                                                                     #
# Sets those in a Security group adapted for Docker Swarm                                                 #
# and for the apps running                                                                                #
###########################################################################################################

provider "aws" {
  #export AWS_ACCESS_KEY_ID="";
  #export AWS_SECRET_ACCESS_KEY="";
  #export AWS_DEFAULT_REGION=""
}

# Your IP Address
variable "IPADDR" {}
variable "KEYNAME" {}

variable "WORKERS" {
  default = "3"
}



# Create the Security Group
resource "aws_security_group" "foxIntel_sg" {
  name        = "foxIntel_sg"
  description = "security group for Fox Intelligence DevOps test"
}

# Opens all the outbound trafic
resource "aws_security_group_rule" "http_egress_all_open" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.foxIntel_sg.id}"
}

# Opens the 8080 group for the front-back connection
resource "aws_security_group_rule" "http_8080_from_all" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.foxIntel_sg.id}"
}

# Opens the 3000 for the frontend
resource "aws_security_group_rule" "http_3000_from_all" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.foxIntel_sg.id}"
}

# Allows you -and ansible- to access the instances
resource "aws_security_group_rule" "ssh_from_me" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.IPADDR}/32"]
  security_group_id = "${aws_security_group.foxIntel_sg.id}"
}

# Port 2377 for inbound swarm manager traffic
resource "aws_security_group_rule" "TCP_2377" {
  type              = "ingress"
  from_port         = 2377
  to_port           = 2377
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.foxIntel_sg.id}"
}

# Port 7946 for communication between nodes
resource "aws_security_group_rule" "TCP_7946" {
  type              = "ingress"
  from_port         = 7946
  to_port           = 7946
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.foxIntel_sg.id}"
}

# Port 7946 for communication between nodes
resource "aws_security_group_rule" "UDP_7946" {
  type              = "ingress"
  from_port         = 7946
  to_port           = 7946
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.foxIntel_sg.id}"
}

# Port 4789 for VXLAN overlay network traffic
resource "aws_security_group_rule" "UDP_4789" {
  type              = "ingress"
  from_port         = 4789
  to_port           = 4789
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.foxIntel_sg.id}"
}

# Gets the image of the last ec2
data "aws_ami" "ec2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*"]
  }

  owners = ["137112412989"] # amazon
}

# Creates the Manager
resource "aws_instance" "Manager" {
  ami           = "${data.aws_ami.ec2.id}"
  instance_type = "t2.micro"

  tags {
    Name = "Manager"
  }

  # Your key used to connect through SSH to instances
  key_name = "${var.KEYNAME}"

  security_groups = ["${aws_security_group.foxIntel_sg.name}"]
  user_data       = "yum -y update && yum -y install python2" # Python for Ansible

  provisioner "local-exec" { # Adds it to the ansible inventory
    command = "echo '[manager]\n${aws_instance.Manager.public_ip}\n[workers]'>Ansible/inventories/inv.ini"
  }
}

# Creates the Manager
resource "aws_instance" "Worker" {
  ami           = "${data.aws_ami.ec2.id}"
  instance_type = "t2.micro"

  tags {
    Name = "Worker${count.index + 1}"
  }

  # Your key used to connect through SSH to instances
  key_name = "${var.KEYNAME}"

  security_groups = ["${aws_security_group.foxIntel_sg.name}"]

  user_data = "yum -y update && yum -y install python2" # Python for Ansible
  count     = "${var.WORKERS}" # Creates WORKERS workers 

  # Need to be created after the manager, else Ansible won't be able to read inventory
  depends_on = ["aws_instance.Manager"]

  provisioner "local-exec" { # Adds it to the ansible inventory
    command = "echo '${self.public_ip}'>>Ansible/inventories/inv.ini"
  }
}