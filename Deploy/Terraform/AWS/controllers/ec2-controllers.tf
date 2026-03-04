// Controller EC2 instance
resource "aws_instance" "k8s_controller" {
  count                  = var.count_controllers
  ami                    = "ami-0b6c6ebed2801a5cb"
  instance_type          = var.type_controllers
  subnet_id              = var.controllers_subnet_id
  vpc_security_group_ids = [var.controllers_sg_id] 
  credit_specification {
    cpu_credits = "standard"
  }
  root_block_device {
    volume_size = var.disk_size
    volume_type = var.disk_type
  }
  tags = {
    Name = "k8s_controller_${count.index}"
  }
}