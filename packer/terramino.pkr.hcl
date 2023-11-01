packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"

    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "terramino"
  instance_type = "t2.micro"
  region        = "us-east-1"
  profile       = "dev"


  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "build_terramino"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "sudo apt -y update",
      "sleep 15",
      "sudo apt -y update",
      "sudo apt -y install apache2",
      "sudo systemctl start apache2",
      "sudo apt -y install php libapache2-mod-php",
      "sudo systemctl restart apache2.service",
      "sleep 15",
      "sudo chown -R ubuntu:ubuntu /var/www/html",
    ]
  }
  provisioner "file" {
    source = "../index.php"
    destination = "/var/www/html/index.php"
  }
  provisioner "file" {
    source = "../index.html"
    destination = "/var/www/html/index.html"
  }
}
