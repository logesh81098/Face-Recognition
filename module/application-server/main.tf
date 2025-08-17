#############################################################################################################################################################################
#                                                                  Application Server
#############################################################################################################################################################################

resource "aws_instance" "application-server" {
  ami = var.ami-id
  instance_type = var.instance-type
  subnet_id = var.subnet-id
  vpc_security_group_ids = [ var.Application-server-SG ]
  key_name = var.keypair
  iam_instance_profile = var.Instance-profile
  ebs_block_device {
    volume_type = var.root-volume-type
    volume_size = var.root-volume-size
    device_name = "/dev/xvda"
  }
  tags = {
    Name = "Rekognition-Application-Server"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
  user_data = <<-EOF
  #!bin/bash
  sudo su
  set -eux
  dnf update -y
  dnf upgrade -y
  dnf install git -y
  git --version
  dnf install docker -y
  systemctl enable docker
  systemctl start docker
  sleep 10
  systemctl status docker
  usermod -aG docker ec2-user
  dnf install -y python3 python3-pip 
  pip install boto3
  cd /
  git clone https://github.com/logesh81098/Face-Recognition.git
  cd Face-Recognition/
  python3 upload-images-to-s3.py
  sleep 10
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  sudo dnf install java-17-amazon-corretto -y
  sudo dnf install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  sudo systemctl status jenkins
  usermod -aG docker jenkins
  reboot
  EOF
}