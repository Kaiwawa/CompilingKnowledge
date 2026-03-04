module "workers" {
  source = "./AWS/workers"
  count_workers = 2
  type_workers = "t3.micro"
  disk_size = 20
  disk_type = "gp3"
}

module "controllers" {
  source = "./AWS/controllers"
  count_controller = 1
  type_controller = "t3.micro"
  disk_size = 10
  disk_type = "gp3"
}

output "controllers_ips" {
  description = "IPs dos controllers"
  value       = module.controllers.public_ip
}

output "workers_ips" {
  description = "IPs dos workers"
  value       = module.workers.public_ip
}