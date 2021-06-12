# IAM configration

# IAM Role
resource "aws_iam_role" "app_iam_role" {
  name = "${var.project}-${var.enviroment}-app-iam-role"
  # 紐付けるデータ本体:信頼ポリシーのjsonオブジェクト
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

}
# IAM Role 信頼ポリシー
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

