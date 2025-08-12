#############################################################################################################################################################################
#                                                                    Key Pair
#############################################################################################################################################################################

resource "tls_private_key" "private-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "face-rekognition-key" {
  key_name = "Face-Rekognition-key"
  public_key = tls_private_key.private-key.public_key_openssh
}

resource "local_file" "face-rekognition-pem" {
  filename = "Face-Rekognition-private-key"
  content = tls_private_key.private-key.private_key_openssh
}