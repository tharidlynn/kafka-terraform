variable "user_name" {
  default = "ubuntu"
}

variable "access_key" {
  
}
variable "secret_key" {
  
}

variable "region" {
  default = "ap-southeast-1"
}

variable "ssh_key_path" {
  
}
variable "ssh_key_name" {
  
}

variable "broker_instance_type" {
  default = "t2.micro"
}

variable "zookeeper_instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-0c5199d385b432989"
}

variable "device_name" {
  default = "/dev/sdf"
}

variable "mount_point" {
  default = "/mnt/kafka"
}