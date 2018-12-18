resource "aws_instance" "kafka_1" {
  instance_type = "${var.broker_instance_type}"
  ami = "${var.ami}"
  subnet_id = "${module.vpc.public_subnets[0]}"
  key_name = "${var.ssh_key_name}"
  vpc_security_group_ids = ["${module.kafka_security_group.this_security_group_id}", "${aws_security_group.ssh.id}"]

  timeouts {
    create = "60m"
    delete = "2h"
  }

  provisioner "file" {
    content = "${data.template_file.mount_volume.rendered}"
    destination = "/tmp/mount-volume.sh"

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }

  provisioner "file" {
    content = "${data.template_file.setup_kafka.rendered}"
    destination = "/tmp/setup-kafka.sh"

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }

  provisioner "file" {
    source = "configs/kafka.service"
    destination = "/tmp/kafka.service"

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo /tmp/mount-volume.sh",
      "rm /tmp/mount-volume.sh",
      "chmod +x /tmp/setup-kafka.sh",
      "sudo /tmp/setup-kafka.sh 1",
      "rm /tmp/setup-kafka.sh",
      "sudo mv /tmp/kafka.service /etc/systemd/system/kafka.service",
      "sudo chmod a+x /etc/systemd/system/kafka.service",
      "sudo systemctl start kafka",
      "sudo systemctl enable kafka"
    ]

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }

  tags {
    Terraform = "true"
    Environment = "dev"
    Name = "kafka_1"
  }
}

resource "aws_instance" "kafka_2" {
  instance_type = "${var.broker_instance_type}"
  ami = "${var.ami}"
  subnet_id = "${module.vpc.public_subnets[0]}"
  key_name = "${var.ssh_key_name}"
  vpc_security_group_ids = ["${module.kafka_security_group.this_security_group_id}", "${aws_security_group.ssh.id}"]

  timeouts {
    create = "60m"
    delete = "2h"
  }

  provisioner "file" {
    content = "${data.template_file.mount_volume.rendered}"
    destination = "/tmp/mount-volume.sh"

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }

  provisioner "file" {
    content = "${data.template_file.setup_kafka.rendered}"
    destination = "/tmp/setup-kafka.sh"

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }

  }

  provisioner "file" {
    source = "configs/kafka.service"
    destination = "/tmp/kafka.service"

    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo /tmp/mount-volume.sh",
      "rm /tmp/mount-volume.sh",
      "chmod +x /tmp/setup-kafka.sh",
      "sudo /tmp/setup-kafka.sh 2",
      "rm /tmp/setup-kafka.sh",
      "sudo mv /tmp/kafka.service /etc/systemd/system/kafka.service",
      "sudo chmod a+x /etc/systemd/system/kafka.service",
      "sudo systemctl start kafka",
      "sudo systemctl enable kafka"
    ]
    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file(var.ssh_key_path)}"
    }
  }

  tags {
    Terraform = "true"
    Environment = "dev"
    Name = "kafka_2"
  }
}


resource "aws_ebs_volume" "kafka_1" {
  availability_zone = "ap-southeast-1a"
  size = 100
  type = "gp2"

  tags {
    Name = "kafka_1"
  }
}

resource "aws_ebs_volume" "kafka_2" {
  availability_zone = "ap-southeast-1a"
  size = 100
  type = "gp2"

  tags {
    Name = "kafka_2"
  }
}


resource "aws_volume_attachment" "kafka_1_ebs_att" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.kafka_1.id}"
  instance_id = "${aws_instance.kafka_1.id}"
}

resource "aws_volume_attachment" "kafka_2_ebs_att" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.kafka_2.id}"
  instance_id = "${aws_instance.kafka_2.id}"
}

