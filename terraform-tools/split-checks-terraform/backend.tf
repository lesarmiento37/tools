terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "leonardo-tfstate-bucket"
    key            = "infrastructure.tfstate"
    dynamodb_table = "terraform_locks"
    #role_arn       = "arn:aws:iam::192783717695:policy/TFStateAccessPolicy"
    encrypt        = "true"
  }
}
