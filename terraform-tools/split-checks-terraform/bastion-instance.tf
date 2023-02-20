resource "aws_instance" "bastion"{
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name = var.ssh_key_name
  security_groups = [aws_security_group.bastion_instance.id]
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnet[0].id##
  lifecycle {
    ignore_changes = [
      disable_api_termination,ebs_optimized,hibernation,security_groups,
      credit_specification,network_interface,ephemeral_block_device]
  }
  tags = {
    Name = "bastion-instance"
  }
}
