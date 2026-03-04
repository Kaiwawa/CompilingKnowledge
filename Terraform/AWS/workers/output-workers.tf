output "worker_ips" {
  value = [for i in range(0, 2) : aws_instance.k8s_workers[i].public_ip]
}