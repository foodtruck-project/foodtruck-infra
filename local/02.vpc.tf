module "vpc" {
  source = "../modules/vpc"
  
  vpc_name          = "foodtruck-vpc"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name        = "VPC"
    Project     = "FoodTruck"
    Environment = "Local"
  }
}