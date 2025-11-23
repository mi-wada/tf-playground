output "ami_id" {
  value = data.aws_ami.linux_2023_arm.id
}

output "ec2_public_ip" {
  value = aws_instance.public.public_ip
}
