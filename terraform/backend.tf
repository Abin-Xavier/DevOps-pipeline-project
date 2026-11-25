terraform {
  backend "s3" {
    bucket       = "devops-pipeline-tfstate-198233241679"
    key          = "devops-pipeline/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
