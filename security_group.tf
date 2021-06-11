# セキュリティグループリソース設定

resource "aws_security_group" "web_sg" {

  name        = "${var.project}-${var.enviroment}-web-sg"
  description = "web front role security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.enviroment}-web-sg"
    Project = var.project
    Env     = var.enviroment
  }

}

resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "web_out_3000" {
  security_group_id        = aws_security_group.web_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.app_sg.id

}
resource "aws_security_group" "app_sg" {

  name        = "${var.project}-${var.enviroment}-app-sg"
  description = "application front role security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.enviroment}-app-sg"
    Project = var.project
    Env     = var.enviroment
  }

}

resource "aws_security_group" "opmg_sg" {

  name        = "${var.project}-${var.enviroment}-opmg-sg"
  description = "operation front role security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.enviroment}-opmg-sg"
    Project = var.project
    Env     = var.enviroment
  }

}

resource "aws_security_group_rule" "opmg_in_ssh" {
  security_group_id = aws_security_group.opmg_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmg_in_3000" {
  security_group_id = aws_security_group.opmg_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmg_out_http" {
  security_group_id = aws_security_group.opmg_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmg_out_https" {
  security_group_id = aws_security_group.opmg_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.enviroment}-db-sg"
  description = "database front role security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.enviroment}-db-sg"
    Project = var.project
    Env     = var.enviroment
  }

}

resource "aws_security_group_rule" "db_in_3306" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app_sg.id
}

