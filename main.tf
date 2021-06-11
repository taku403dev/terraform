# initオプション: 初期化処理の定義
provider "aws" {
	profile = "terraform"
	region = "ap-northeast-1"
}

# applyオプション: インスタンスの定義
resource "aws_instance" "hello-world" {
	ami = "ami-001f026eaf69770b4"
	instance_type = "t2.micro"

	tags = {
		Name = "HelloWorld" 
	}
	user_data = <<EOF
	#!/bin/bash
	amazon-linux-extras install -y nginx
	systemctl start nginx
	EOF
}