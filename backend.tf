terraform {
  backend "s3" {
    bucket = "terraform-backend-files-logesh"
    key = "face-rekognition-terraform.tfstate"
    region = "us-east-1"
  }
}