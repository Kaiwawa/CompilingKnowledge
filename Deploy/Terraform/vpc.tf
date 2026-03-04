resource "aws_vpc" "vpc-k8s" {
  cidr_block           = "172.32.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-k8s"
  }
}

resource "aws_subnet" "subnet-k8s" {
  vpc_id                              = aws_vpc.vpc-k8s.id
  cidr_block                          = "172.32.86.0/24"
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "subnet-k8s"
  }
}


resource "aws_internet_gateway" "gateway-k8s" {
  vpc_id = aws_vpc.vpc-k8s.id
  tags = {
    Name = "gateway-k8s"
  }
}

resource "aws_route_table" "route-k8s" {
  vpc_id = aws_vpc.vpc-k8s.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway-k8s.id
  }
  route {
    cidr_block       = "172.32.0.0/16"
    local_gateway_id = "local"
  }
  tags = {
    Name = "route-k8s"
  }
}

resource "aws_route_table_association" "route-table-k8s" {
  subnet_id      = aws_subnet.subnet-k8s.id
  route_table_id = aws_route_table.route-k8s.id
}

resource "aws_security_group" "sg-k8s-controllers" {
  name   = "k8s-controllers"
  vpc_id = aws_vpc.vpc-k8s.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my-ip}/32"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["${var.my-ip}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg-k8s-workers" {
  name   = "k8s-workers"
  vpc_id = aws_vpc.vpc-k8s.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_workers_communication" {
  ip_protocol              = "-1"
  security_group_id        = aws_security_group.sg-k8s-workers.id
  referenced_security_group_id = aws_security_group.sg-k8s-controllers.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_controllers_communication" {
  ip_protocol              = "-1"
  security_group_id        = aws_security_group.sg-k8s-controllers.id
  referenced_security_group_id = aws_security_group.sg-k8s-workers.id
}