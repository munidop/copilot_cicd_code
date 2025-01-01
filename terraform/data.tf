data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_iam_role" "eksClusterRole" {
    name = "eksClusterRole"
}

data "aws_iam_role" "eksNodeRole" {
    name = "eks-node-role"
}