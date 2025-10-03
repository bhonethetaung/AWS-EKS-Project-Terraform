resource "aws_security_group" "rds_sg" {
  name        = "${var.rds_cluster_name}-sg"
  description = "Security group for RDS cluster"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.rds_cluster_name}-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  tags = {
    Name = "${var.rds_cluster_name}-subnet-group"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.rds_cluster_name
  engine                  = var.rds_engine
  engine_mode             = var.cluster_engine_mode
  master_username         = var.rds_username
  master_password         = var.rds_password
  database_name           = var.db_name
  skip_final_snapshot     = true
  storage_encrypted       = true

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                   = 2
  identifier              = "aurora-instance-${count.index}"
  cluster_identifier      = aws_rds_cluster.aurora_cluster.id
  instance_class          = var.rds_instance_type
  engine                  = aws_rds_cluster.aurora_cluster.engine
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
}