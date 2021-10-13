resource "aws_key_pair" "master-key" {
  provider   = aws.provider
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "jenkins-master" {
  provider                    = aws.provider
  ami                         = var.ami
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "jenkins_master_tf"
  }

  user_data = <<EOF
#! /bin/sh
yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
EOF

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}