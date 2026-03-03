resource "aws_vpc" "devops_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "DevOpsChallenge-Day2-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "DevOpsChallenge-IGW"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "DevOpsChallenge-PublicSubnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "DevOpsChallenge-PublicRT"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for K3s Control Plane and Workers
resource "aws_security_group" "k3s_sg" {
  name        = "k3s_cluster_sg"
  description = "Allow inbound traffic for K3s and SSH"
  vpc_id      = aws_vpc.devops_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, restrict to your IP
  }

  ingress {
    description = "K3s Kubernetes API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, restrict to your IP
  }

  ingress {
    description = "Flannel VXLAN (Internal)"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOpsChallenge-K3sSG"
  }
}
