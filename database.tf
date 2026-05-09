resource "aws_db_subnet_group" "main" {
  name       = "webapp-db-subnet"
  subnet_ids = [aws_subnet.app.id, aws_subnet.db.id]
  depends_on = [aws_subnet.app, aws_subnet.db]
}
resource "aws_db_instance" "postgres" {
  identifier             = "webapp-postgres"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.t3.medium"
  allocated_storage      = 50
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  depends_on = [aws_db_subnet_group.main, aws_security_group.db_sg]
}
resource "aws_elasticache_subnet_group" "cache" {
  name       = "webapp-cache-subnet"
  subnet_ids = [aws_subnet.app.id]
}
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "webapp-cache"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.cache.name
  security_group_ids   = [aws_security_group.web_sg.id]
  depends_on = [aws_elasticache_subnet_group.cache]
}
