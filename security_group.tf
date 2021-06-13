# セキュリティグループ設定

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

resource "aws_security_group_rule" "web_in_web_port" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.web_port
  to_port           = var.web_port
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
# アウトバウンド: tcp/http: to app server
resource "aws_security_group_rule" "web_out_app_port" {
  security_group_id        = aws_security_group.web_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.app_port
  to_port                  = var.app_port
  source_security_group_id = aws_security_group.app_sg.id

}
# application security group
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

# インバウンド: tcp/http: in app server
resource "aws_security_group_rule" "app_in_app_port" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.app_port
  to_port                  = var.app_port
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "app_out_http" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.web_port
  to_port           = var.web_port
  prefix_list_ids   = [data.aws_prefix_list.s3_p1.id]
}

resource "aws_security_group_rule" "app_out_https" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = [data.aws_prefix_list.s3_p1.id]
}

resource "aws_security_group_rule" "app_out_db" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.db_port
  to_port                  = var.db_port
  source_security_group_id = aws_security_group.db_sg.id
}

# Operation manager security group
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

resource "aws_security_group_rule" "opmg_in_app_port" {
  security_group_id = aws_security_group.opmg_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.app_port
  to_port           = var.app_port
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmg_out_web_port" {
  security_group_id = aws_security_group.opmg_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.web_port
  to_port           = var.web_port
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


# Database security group configration
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

# inbound database port
resource "aws_security_group_rule" "db_in_db_port" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.db_port
  to_port                  = var.db_port
  source_security_group_id = aws_security_group.app_sg.id
}

