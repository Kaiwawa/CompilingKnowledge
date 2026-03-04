// Worker EC2 instances
resource "aws_instance" "k8s_workers" {
  count                  = var.count_workers
  ami                    = "ami-0b6c6ebed2801a5cb"
  instance_type          = var.type_workers
  subnet_id              = var.workers_subnet_id
  vpc_security_group_ids = [var.workers_sg_id]
  credit_specification {
    cpu_credits = "standard"
  }
  root_block_device {
    volume_size = var.disk_size
    volume_type = var.disk_type
  }
  tags = {
    Name = "k8s_worker_${count.index}"
  }
}