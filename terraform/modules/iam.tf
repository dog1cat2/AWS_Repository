data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# SSM - SSH 서버 접속시 사용
data "aws_iam_policy" "systems_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# 로그 수집시 사용 - CloudWatch
data "aws_iam_policy" "cloudwatch_agent" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}
# ECR 에서 Container를 다운 받을 때 사용
data "aws_iam_policy" "ecr_access"{
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
# CodeCommit의 접근 권한
data "aws_iam_policy" "codecommit_access" {
  arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

# IAM Role

##################################################################
## bastion
##################################################################
resource "aws_iam_role" "bastion" {
  name               = "${var.project_name}-${var.environment}-bastion-iamrole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = data.aws_iam_policy.systems_manager.arn
}

resource "aws_iam_role_policy_attachment" "bastion_cloudwatch" {
  role       = aws_iam_role.bastion.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent.arn
}
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.project_name}-${var.environment}-bastion-instanceprofile"
  role = aws_iam_role.bastion.name
}
