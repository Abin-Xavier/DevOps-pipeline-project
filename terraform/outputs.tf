output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.compute.instance_id
}

output "public_ip" {
  description = "Public IP of the server"
  value       = module.compute.public_ip
}

output "ssh_command" {
  description = "Command to log in to the server"
  value       = "ssh -i ~/.ssh/devops-key ubuntu@${module.compute.public_ip}"
}
