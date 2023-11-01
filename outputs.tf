# Outputs file
output "terramino_url" {
  value = "http://${aws_eip.terramino.public_dns}"
}

output "terramino_ip" {
  value = "http://${aws_eip.terramino.public_ip}"
}
