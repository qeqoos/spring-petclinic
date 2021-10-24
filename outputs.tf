output "Jenkins-master-public-IP" {
  value = aws_instance.jenkins-master.public_ip
}

output "Jenkins-worker-public-IP" {
  value = aws_instance.jenkins-worker.public_ip
}

output "qa-instance-public-IP" {
  value = aws_instance.qa_instance.public_ip
}