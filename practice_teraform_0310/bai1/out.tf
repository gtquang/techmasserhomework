output "web_site" {
  value = "http://${aws_instance.web.public_ip}"
}