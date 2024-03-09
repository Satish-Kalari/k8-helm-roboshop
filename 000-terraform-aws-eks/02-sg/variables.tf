variable "project_name" {
  default = "roboshop"  
}

variable "environment" {
  default = "dev"    
}

variable "common_tags" {
  default = {
    project = "roboshop"
    environment = "dev"
    terraform = "true"
  }    
}

variable "sg_tags" {
  default = {}    
}