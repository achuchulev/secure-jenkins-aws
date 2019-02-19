module "random_name" {
  source = "github.com/achuchulev/module-random_pet"
}

resource "aws_key_pair" "my_key" {
  key_name   = "key-${module.random_name.name}"
  public_key = "${var.public_key}"
}

resource "aws_instance" "new_ec2" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"

  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  key_name               = "${aws_key_pair.my_key.id}"

  tags {
    Name = "Jenkins_${module.random_name.name}"
  }

  provisioner "file" {
    source      = "config/"
    destination = "~/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    script = "${path.root}/scripts/provision.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

# Create a record
resource "cloudflare_record" "my-hostA-record" {
  domain = "${var.cloudflare_zone}"
  name   = "${var.subdomain_name}"
  value  = "${aws_instance.new_ec2.public_ip}"
  type   = "A"
  ttl    = 3600

  provisioner "remote-exec" {
    inline = [
      "sudo certbot --nginx --non-interactive --agree-tos -m ${var.cloudflare_email} -d ${var.subdomain_name}.${var.cloudflare_zone} --redirect",
    ]

    connection {
      type        = "ssh"
      host        = "${aws_instance.new_ec2.public_ip}"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    script = "${path.root}/scripts/unlock.sh"

    connection {
      type        = "ssh"
      host        = "${aws_instance.new_ec2.public_ip}"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}
