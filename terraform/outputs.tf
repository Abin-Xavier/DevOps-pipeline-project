output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP of the server"
  value       = aws_instance.web.public_ip
}

output "ssh_command" {
  description = "Command to log in to the server"
  value       = "ssh -i ~/.ssh/devops-key ubuntu@${aws_instance.web.public_ip}"
}
