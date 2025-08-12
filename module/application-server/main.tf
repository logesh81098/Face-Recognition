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
}