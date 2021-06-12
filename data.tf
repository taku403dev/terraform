# 外部リソース設定

# S3設定
data "aws_prefix_list" "s3_p1" {
  name = "com.amazonaws.*.s3"
}

# AMIを検索して取り込む設定
# aws cli 下記コマンド利用して検索
# aws ec2 describe-images --image-ids イメージIDを指定
data "aws_ami" "app" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}