# terraform 基本設定
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }

  # ローカル環境下に存在するterraform.tfstateを
  # 下記s3バケットに保存先を変更
  backend "s3" {
    bucket  = "tastylog-tfstate-bucket-takurou403"
    key     = "tastylog-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}
# provider設定
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}


# 外部変数はterraform.tfvarsに定義されている
# 下記は型定義のみ設定

# プロジェクトで利用する変数定義
variable "project" {
  type = string
}

# 環境変数の定義
variable "enviroment" {
  type = string
}