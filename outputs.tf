output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "aws-id-demo-subnet" {
  value = aws_subnet.demo-subnet.id
}
output "server_public_ip" {
  description = "Server public ip for ssh access"
  value       = aws_instance.server[0].public_ip
}
output "client_public_ip" {
  description = "Client public ip for ssh access"
  value       = aws_instance.client[0].public_ip
}
output "region" {
  value = "us-east-1"
}

output "subnet_id" {
  value = aws_subnet.demo-subnet.id
}