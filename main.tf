resource "aws_instance" "test" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.test.id
  associate_public_ip_address = true
  tags = {
    Name="Mahi"
  }
}