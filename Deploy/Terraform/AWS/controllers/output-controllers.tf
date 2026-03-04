output "controller_private_ips" {
  value = aws_instance.k8s_controller[*].private_ip
}
output "controller_public_ip" {
  value = aws_instance.k8s_controller[*].public_ip
}
output "controller_public_dns" {
  value = aws_instance.k8s_controller[*].public_dns
}