output "ami" {
  value = data.aws_ami.linux_2023_x86.id
}

output "alb_dns" {
  value = aws_lb.example.dns_name
}

output "test" {
  value = "test"
}
