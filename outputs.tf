output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "region" {
  value = "us-east-1"
}
output "private_ip" {
  value = "172.16.0.5/32"
}

output "subnet_id" {
  value = "aws_subnet.public_a.id"
}