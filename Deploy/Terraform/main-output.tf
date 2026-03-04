// Output for EC2
output "controllers_private_ips" {
  description = "IPs dos controllers"
  value       = module.controllers.controller_private_ips
}
output "controller_public_ip" {
  value = module.controllers.controller_public_ip
}
output "controller_public_dns" {
  value = module.controllers.controller_public_dns
}
output "workers_private_ips" {
  description = "IPs dos workers"
  value       = module.workers.worker_private_ips
}
output "worker_public_ips" {
  value = module.workers.worker_public_ips
}
output "worker_public_dns" {
  value = module.workers.worker_public_dns
}


// Output for VPC
output "vpc_id" {
  value = aws_vpc.vpc-k8s.id
}
output "subnet_id" {
  value = aws_subnet.subnet-k8s.id
}
output "gateway_id" {
  value = aws_internet_gateway.gateway-k8s.id
}
output "route_table_id" {
  value = aws_route_table.route-k8s.id
}
output "security_group_id_controllers" {
  value = aws_security_group.sg-k8s-controllers.id
}
output "security_group_id_workers" {
  value = aws_security_group.sg-k8s-workers.id
}
