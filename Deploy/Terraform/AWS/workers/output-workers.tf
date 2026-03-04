output "worker_ips" {
  value = aws_instance.k8s_workers[*].public_ip
}