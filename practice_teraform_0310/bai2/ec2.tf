resource "aws_instance" "web" {
  ami             = "ami-0ff89c4ce7de192ea"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.generated_key.key_name
  security_groups = ["web_golang"]
  user_data = file("script.sh")
  tags = {
    Name = "golang"
  }
}