terraform {
  backend "s3" {
    bucket  = "course-s3"
    encrypt = "true"
    key     = "Live/EUWest3/Bastion/Navylus"
    region  = "eu-west-3"
  }
}
