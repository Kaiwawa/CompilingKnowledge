output "worker_private_ips" {
  value = aws_instance.k8s_workers[*].private_ip
}
output "worker_public_ips" {
  value = aws_instance.k8s_workers[*].public_ip
}
output "worker_public_dns" {
  value = aws_instance.k8s_workers[*].public_dns
}