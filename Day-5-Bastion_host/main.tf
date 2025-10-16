#Bastion_Host Process
#create A vpc 
resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Bastion_vpc"
  }
}
#create a Public Subnet
resource "aws_subnet" "subPU" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "Public_subnet"
  }
}
#Create a Private Subnet
resource "aws_subnet" "subPR" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Private_subnet"
  }
}
#Create a IG
resource "aws_internet_gateway" "IG_B" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "Internet_Bastion"
  }
}
#craete a route Table and edit rote and attach to innternet Gateway
resource "aws_route_table" "prodPU" {
  vpc_id = aws_vpc.prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG_B.id
  }
  tags = {
    Name = "PUBRT"
  }
}
#Route_table Association with public subnet
resource "aws_route_table_association" "PURT_ASS" {
  subnet_id = aws_subnet.subPU.id
  route_table_id = aws_route_table.prodPU.id

}
#Create a Security Group for Public Instance
resource "aws_security_group" "SG_B" {
  description = "allow tls ports "
  name = "Allow tls"
  vpc_id = aws_vpc.prod.id
  tags ={
    Name = "Prod_SG"
  }
  ingress {
    description = "ALLOW SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "ALLOW SSH"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ALLOW SSH"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
    description = "ALLOW SSH"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }
}
# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
 tags = {
    Name = "NAT_EIP"
  }

}

# Elastic IP for Public EC2
resource "aws_eip" "ec2_eip" {
  instance = aws_instance.public_ec2.id
  domain   = "vpc"
}

# NAT Gateway using its own EIP
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subPU.id
  tags = {
    Name = "NAT_GT"
  }
}

#Create a public Instance with public Ip
resource "aws_instance" "public_ec2" {
  ami= var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.subPU.id   
  vpc_security_group_ids = [aws_security_group.SG_B.id]
  associate_public_ip_address = true    
  tags = {
    Name = "public_ec2"
  }
}
#craete a Rote Table for private instance and Attach to Nat
resource "aws_route_table" "prodPR" {
  vpc_id = aws_vpc.prod.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id

  }
 tags = {
   Name = "PVRRT"
 }  
}
#Private RT attachment
resource "aws_route_table_association" "PR_ASS" {
  subnet_id = aws_subnet.subPR.id
  route_table_id = aws_route_table.prodPR.id
}
#Create a Private Instance with Private Ip
resource "aws_instance" "Private_ec2" {
  ami= var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.subPR.id   
  vpc_security_group_ids = [aws_security_group.SG_B.id]
  associate_public_ip_address = false   
  tags = {
    Name = "Private_ec2"
  }
}
