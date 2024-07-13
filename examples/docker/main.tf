terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}
        
variable "app_container_name"{
    type = string
    default = "flask-app-container"
}

variable "container_vars" {
  type = map(string)
  default = {
    BANK_DATA_URL = "https://random-data-api.com/api/v2/banks"
  }
}

resource "docker_image" "app" {
  name = "app"
  build {
    context = "./src/."
    tag     = ["app:1.0"]
    build_arg = {
      app : "api"
    }
    label = {
      author : "nash"
    }
  }
}

resource "docker_container" "flask-app" {
  image = docker_image.app.image_id
  name  = var.app_container_name

  ports {
    internal = 5000
    external = 5000
  }

  env = [for key, value in var.container_vars : "${key}=${value}"]

  depends_on = [
    docker_image.app
  ]
}

