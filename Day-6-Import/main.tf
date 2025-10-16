provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "importec2" {
  ami = "ami-0341d95f75f311023"
  instance_type = "t2.micro"
  key_name = "heena-key" 
  availability_zone = "us-east-1b"
  tags = {
    Name = "beautiful_instance"
  }
}