# rds parameter group
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.enviroment}-mysql-standalone-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# rds option group
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.enviroment}-mysql-standalone-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# rds subnet group
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.enviroment}-mysql-standalone-group"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]
  tags = {
    Name    = "${var.project}-${var.enviroment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.enviroment
  }

}

# rds instance
resource "aws_db_instance" "mysql_standalone" {
  engine         = "mysql"
  engine_version = "8.0.20"
  identifier     = "${var.project}-${var.enviroment}-mysql-standalone"
  username       = "admin"
  password       = random_string.db_password.result
  #   インスタンス設定
  instance_class = "db.t2.micro"
  #   ストレージ設定
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false
  # ネットワーク設定
  multi_az          = false
  availability_zone = "ap-northeast-1a"
  # サブネット指定
  db_subnet_group_name = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [
    aws_security_group.db_sg.id
  ]
  publicly_accessible = false
  port                = 3306

  # データベース名
  name                 = "tastylog"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name

  # バックアップを先に実行してからメンテナンスを実行する設定
  # バックアップを実行する時間帯指定
  backup_window = "04:00-05:00"
  # バックアップを保管する期間の日付指定
  backup_retention_period = 7
  # メンテナンス日時を指定
  maintenance_window = "Mon:05:00-Mon:08:00"
  # バージョンを自動でアップグレード設定
  auto_minor_version_upgrade = false
  # 削除保護設定
  deletion_protection = false
  #   スナップショット削除時にスナップショット作成設定
  skip_final_snapshot = true

  # 即時作成設定
  apply_immediately = true
  tags = {
    Name    = "${var.project}-${var.enviroment}-mysql-standalone"
    Project = var.project
    Env     = var.enviroment
  }
}