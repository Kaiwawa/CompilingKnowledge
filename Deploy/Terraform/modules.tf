module "workers" {
  source            = "./AWS/workers"
  region            = "us-east-1"
  count_workers     = 1
  type_workers      = "t3.micro"
  disk_size         = 10
  disk_type         = "gp3"
  workers_subnet_id = aws_subnet.subnet-k8s.id
  workers_sg_id     = aws_security_group.sg-k8s-workers.id
}

module "controllers" {
  source                = "./AWS/controllers"
  count_controllers     = 1
  region                = "us-east-1"
  type_controllers      = "t3.micro"
  disk_size             = 10
  disk_type             = "gp3"
  controllers_subnet_id = aws_subnet.subnet-k8s.id
  controllers_sg_id     = aws_security_group.sg-k8s-controllers.id
}