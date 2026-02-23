output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.rhel_server[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.rhel_server[*].public_ip
}

output "instance_public_dns" {
  description = "Public DNS names of the instances"
  value       = aws_instance.rhel_server[*].public_dns
}

output "vault_ssh_key_path" {
  description = "Path to SSH private key in Vault"
  value       = vault_generic_secret.ssh_private_key.path
}

output "ssh_connections" {
  description = "How to connect to the servers"
  value = join("\n\n", [
    for i, ip in aws_instance.rhel_server[*].public_ip :
    "Instance ${i + 1}:\n1. Get key: vault kv get -field=private_key ${vault_generic_secret.ssh_private_key.path} > key.pem && chmod 600 key.pem\n2. Connect: ssh -i key.pem ec2-user@${ip}"
  ])
}

output "instance_summary" {
  description = "Summary of all instances"
  value = {
    for i, instance in aws_instance.rhel_server :
    instance.tags["Name"] => {
      id         = instance.id
      public_ip  = instance.public_ip
      public_dns = instance.public_dns
    }
  }
}

output "aap_workflow_job" {
  value = aap_workflow_job.workflow_job
}
