resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = var.public_key
}