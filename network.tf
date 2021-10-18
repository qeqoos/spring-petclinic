resource "aws_vpc" "main_vpc" {
  provider             = aws.provider
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  provider = aws.provider
  vpc_id   = aws_vpc.main_vpc.id
}

data "aws_availability_zones" "azs" {
  provider = aws.provider
  state    = "available"
}

#Create route table in us-east-1
resource "aws_route_table" "internet_route" {
  provider = aws.provider
  vpc_id   = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Master-Region-RT"
  }
}

resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.provider
  vpc_id         = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.internet_route.id
}

resource "aws_subnet" "subnet_1" {
  provider          = aws.provider
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "subnet_2" {
  provider          = aws.provider
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
}

resource "aws_subnet" "subnet_3" {
  provider          = aws.provider
  availability_zone = element(data.aws_availability_zones.azs.names, 2)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
}

resource "aws_security_group" "jenkins-master" {
  provider    = aws.provider
  name        = "jenkins-master"
  description = "Allow TCP/8080 & TCP/22, from worker subnet"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow anyone on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow from subnet_2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.2.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins-sg-worker" {
  provider = aws.region-default

  name        = "jenkins-sg-worker"
  description = "TCP/22, 80, all from master subnet"
  vpc_id      = aws_vpc.main_vpc.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow traffic from subnet_1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }
  ingress {
    description = "allow anyone on port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}