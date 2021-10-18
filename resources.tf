resource "aws_key_pair" "master-key" {
  provider   = aws.provider
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_key_pair" "worker-key" {
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
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-master.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "jenkins_master_tf"
  }

  user_data = <<EOF
  #!/bin/bash
  sudo amazon-linux-extras install epel -y
  EOF

  provisioner "local-exec" {
    command = <<EOF
    aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-default} --instance-ids ${self.id} \
    && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible/master-jenkins-install.yml
    EOF
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}

resource "aws_instance" "jenkins-worker" {
  provider                    = aws.provider
  ami                         = var.ami
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-worker.id]
  subnet_id                   = aws_subnet.subnet_2.id

  tags = {
    Name = "jenkins_worker_tf"
  }

  user_data = <<EOF
  #!/bin/bash
  sudo amazon-linux-extras install epel -y
  EOF

  provisioner "local-exec" {
    command = <<EOF
    aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-default} --instance-ids ${self.id} \
    && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible/worker-setup.yml
    EOF
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc, aws_instance.jenkins-master]
}