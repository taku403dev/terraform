# 外部リソース設定

# S3設定
data "aws_prefix_list" "s3_p1" {
  name = "com.amazonaws.*.s3"
}