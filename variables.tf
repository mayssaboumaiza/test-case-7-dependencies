variable "aws_region"     { default = "eu-west-1" }
variable "project_name"   { default = "webapp" }
variable "environment"    { default = "prod" }
variable "db_password"    { sensitive = true }
