output "controller_ips" {
  value = aws_instance.k8s_controller[*].public_ip
}