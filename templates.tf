data "template_file" "mount_volume" {
  template = "${file("${path.module}/scripts/mount-volume.sh.tpl")}"
  vars {
    device_name = "${var.device_name}"
    mount_point = "${var.mount_point}"
  }
}

data template_file "setup_kafka" {
  template = "${file("${path.module}/scripts/setup-kafka.sh.tpl")}"
  vars {
    mount_point = "${var.mount_point}"
    zookeeper_connect = "${aws_instance.zookeeper.public_ip}:2181"
    num_partitions = 1
    log_retention = 168
    repl_factor = 2
  }
}

data "template_file" "setup_zookeeper" {
  template = "${file("${path.module}/scripts/setup-zookeeper.sh.tpl")}"
}

