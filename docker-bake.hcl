variable "TAG" {
  default = ""
}

group "default" {
  targets = ["docker-kakaotalk"]
}

target "docker-remote-desktop" {
  context = "./docker-remote-desktop"
  dockerfile = "Dockerfile"
  tags = [
    "jeewangue/docker-remote-desktop:latest",
    notequal("",TAG) ? "jeewangue/docker-remote-desktop:${TAG}": ""
  ]
  platforms = ["linux/amd64"]
}

target "docker-wine" {
  context = "./docker-wine"
  dockerfile = "Dockerfile"
  tags = [
    "jeewangue/docker-wine:latest",
    notequal("",TAG) ? "jeewangue/docker-wine:${TAG}": ""
  ]
  contexts = {
    docker-remote-desktop = "target:docker-remote-desktop"
  }
  platforms = ["linux/amd64"]
}

target "docker-kakaotalk" {
  dockerfile = "Dockerfile"
  tags = [
    "jeewangue/docker-kakaotalk:latest",
    notequal("",TAG) ? "jeewangue/docker-kakaotalk:${TAG}": ""
  ]
  contexts = {
    docker-wine = "target:docker-wine"
  }
  platforms = ["linux/amd64"]
}

