resource "aws_vpc" "main" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "main-vpc"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main-igw"
    }
}

resource "aws_subnet" "main" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.subnet_tags, { Name = "main-subnet-${count.index + 1}" })
}
resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "main-route-table"
    }
}

resource "aws_route_table_association" "a" {
    count          = 2
    subnet_id      = aws_subnet.main[count.index].id
    route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
    vpc_id = aws_vpc.main.id

    dynamic "ingress" {
        for_each = [
            { port = 22, cidr_block = "223.186.153.90/32" },
            { port = 80, cidr_block = "10.1.0.0/16" }
        ]
        content {
            from_port   = ingress.value.port
            to_port     = ingress.value.port
            protocol    = "tcp"
            cidr_blocks = [ingress.value.cidr_block]
        }
    }

    tags = {
        Name = "main-security-group"
    }
}

resource "aws_eks_cluster" "main" {
  name     = "main-eks-cluster"
  role_arn = data.aws_iam_role.eksClusterRole.arn

  vpc_config {
    subnet_ids = aws_subnet.main[*].id
  }

  tags = {
    Name = "main-eks-cluster"
  }
}

resource "aws_eks_node_group" "main" {
    cluster_name    = aws_eks_cluster.main.name
    node_group_name = "main-eks-node-group"
    node_role_arn   = data.aws_iam_role.eksNodeRole.arn
    subnet_ids      = aws_subnet.main[*].id
    capacity_type   = "ON_DEMAND"
    disk_size       = 20
    instance_types  = ["t3.large"]

    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }

    remote_access {
        ec2_ssh_key = "Neeharika_Terraform"
        source_security_group_ids = [aws_security_group.main.id]
    }

    tags = {
        Name = "main-eks-node-group"
    }
}
