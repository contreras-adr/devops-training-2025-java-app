terraform {
  backend "s3" {
    bucket         = "devops-training-2025-terraform-tfstate"  # cambia si usaste otro nombre de proyecto
    key            = "global/s3/java-app-terraform.tfstate"
    region         = "us-east-1"
    profile        = "devops-training-2025"
    encrypt        = true
  }
}