# Create vpc
resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name =  "Test_vpc"
  }
}
#Create a subnet

resource "aws_subnet" "test" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "test_sub"
  }
}
#Create InternetGateway 
resource "aws_internet_gateway" "test_IG" {
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "test_ig"
  }
}
#Create Route Table and Edit 
resource "aws_route_table" "test_RT" {
    vpc_id = aws_vpc.test.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test_IG.id
    
    }
    tags = {
      Name = "Cust_RT"
    }
  
}
# Route Table association
resource "aws_route_table_association" "RT" {
    route_table_id = aws_route_table.test_RT.id
    subnet_id = aws_subnet.test.id
  
}

resource "aws_security_group" "SG" {
  vpc_id = aws_vpc.test.id
  name = "SG"
  
  ingress {
    description = "allow http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "allow tls"
  }
}
