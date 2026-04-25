data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "snapshot-vpc"
  }
}

resource "aws_subnet" "private" {
  count = 2

  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidrs[count.index]

  availability_zone = local.selected_azs[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Lambda SG - restrict outbound to VPC endpoint only"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "lambda-sg"
  }
}

resource "aws_security_group" "vpce_sg" {
  name        = "vpce-sg"
  description = "VPC Endpoint SG for EC2 API"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "vpce-sg"
  }
}

resource "aws_security_group_rule" "lambda_egress_https_to_vpce" {
  type                     = "egress"
  description              = "Allow HTTPS to VPC Endpoint"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lambda_sg.id
  source_security_group_id = aws_security_group.vpce_sg.id
}

resource "aws_security_group_rule" "vpce_ingress_https_from_lambda" {
  type                     = "ingress"
  description              = "Allow HTTPS from Lambda SG"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpce_sg.id
  source_security_group_id = aws_security_group.lambda_sg.id
}

resource "aws_security_group_rule" "vpce_egress_all" {
  type              = "egress"
  description       = "Allow outbound to AWS services"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.vpce_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.ec2"
  vpc_endpoint_type = "Interface"

  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.vpce_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "ec2-endpoint"
  }
}