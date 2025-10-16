output "ip" {
  value = aws_instance.public_ec2.public_ip
}
output "public_ip" {
  value = aws_instance.Private_ec2.public_ip
}
output "private_ip" {
  value = aws_instance.public_ec2.private_ip
  sensitive = false
}
output "pr_ip" {
  value = aws_instance.Private_ec2.private_ip
  sensitive = false
}