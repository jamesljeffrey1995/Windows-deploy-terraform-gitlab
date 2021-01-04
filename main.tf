variable "name" {}
variable "pipeline" {}
variable "key" {}

provider "aws" {
  region     = "eu-west-2"
}

resource "aws_instance" "example" {
  ami                    = "ami-05c6b990b0e19b937"
  instance_type          = "t2.micro"
  key_name               = "Jeffrey"
  get_password_data      = true
  vpc_security_group_ids = ["sg-0b934bd842056484c"]
  user_data              = "${data.template_file.init.rendered}"
  tags = {
    Name = join(".", [var.name, var.pipeline])
  }
}

data "template_file" "init" {
  template = file("ansibleconfig.ps1")
}

resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
  {
    password = (rsadecrypt(aws_instance.example.password_data,file(var.key))),
    ip       = aws_instance.example.*.public_ip
  }
    )
    filename = "inventory"
    }

