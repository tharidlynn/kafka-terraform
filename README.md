# kafka-terraform
Provisioning Kafka with Terraform on aws


Do note that this repo is heavily underdeveloped ! The purpose of this repo is to be the reference for my future project. 


There are plenty of room for improvement on this code. For example:
- Using null resources instead of remote exec
- Deploying to private subnets
- Executing mount ebs volumes on ubuntu automatically
- Dynamic counting instances on ec2 - numbers of zookeeper and kafka instances.
