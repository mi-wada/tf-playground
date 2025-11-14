terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.0"
    }
  }
}

# variable "container_name" {
#   default     = "tutorial-nginx"
#   type        = string
#   description = "The name of the container"
# }

# provider "docker" {
#   host = "unix:///var/run/docker.sock"
# }

# resource "docker_image" "nginx" {
#   name         = "nginx:latest"
#   keep_locally = true
# }

# resource "docker_container" "nginx" {
#   image = docker_image.nginx.image_id
#   name  = var.container_name

#   ports {
#     internal = 80
#     external = 8000
#   }
# }
