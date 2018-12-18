resource "aws_instance" "zookeeper" {
  ami           = "${var.ami}"
  instance_type = "${var.zookeeper_instance_type}"
  key_name = "${var.ssh_key_name}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}", "${aws_security_group.zookeeper.id}"]
  subnet_id = "${module.vpc.public_subnets[0]}"
  associate_public_ip_address = true

  timeouts {
    create = "60m"
    delete = "2h"
  }

  provisioner "file" {
    content = "${data.template_file.setup_zookeeper.rendered}"
    destination = "/tmp/setup-zookeeper.sh"

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }

  }
  provisioner "file" {
    source = "configs/zookeeper.service"
    destination = "/tmp/zookeeper.service"

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }
 
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-zookeeper.sh",
      "sudo /tmp/setup-zookeeper.sh",
      "rm /tmp/setup-zookeeper.sh",
      "sudo mv /tmp/zookeeper.service /etc/systemd/system/zookeeper.service",
      "sudo chmod a+x /etc/systemd/system/zookeeper.service",
      "sudo systemctl start zookeeper",
      "sudo systemctl enable zookeeper"
    ]

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }

  tags {
    Name = "zookeeper" 

  }
}