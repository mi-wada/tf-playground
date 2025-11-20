output "vpc_id" {
  description = "The ID of VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_name" {
  description = "The name of VPC"
  value       = aws_vpc.vpc.tags["Name"]
}
