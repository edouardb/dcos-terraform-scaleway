provider "scaleway" {
  organization = "${var.organization_key}"
  access_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "scaleway_server" "dcos_bootstrap" {
  name = "${format("${var.dcos_cluster_name}-bootstrap-%02d", count.index)}"
  image = "${var.base_image_id}"
  dynamic_ip_required = "${var.dynamic_ip}"
  type = "${var.scaleway_boot_type}"
  connection {
    user = "${var.user}"
    private_key = "${file(var.dcos_ssh_key_path)}"
  }

  provisioner "local-exec" {
    command = "rm -rf ./scw-install.sh"
  }
  provisioner "local-exec" {
    command = "echo BOOTSTRAP=\"${scaleway_server.dcos_bootstrap.public_ip}\" >> ips.txt"
  }
  provisioner "local-exec" {
    command = "echo CLUSTER_NAME=\"${var.dcos_cluster_name}\" >> ips.txt"
  }
  provisioner "remote-exec" {
  inline = [
    "wget -q -O dcos_generate_config.sh -P $HOME ${var.dcos_installer_url}",
    "mkdir $HOME/genconf"
    ]
  }
  provisioner "local-exec" {
    command = "./make-files.sh"
  }
  provisioner "local-exec" {
    command = "sed -i -e '/^- *$/d' ./config.yaml"
  }
  provisioner "file" {
    source = "./ip-detect"
    destination = "$HOME/genconf/ip-detect"
  }
  provisioner "file" {
    source = "./config.yaml"
    destination = "$HOME/genconf/config.yaml"
  }
  provisioner "remote-exec" {
    inline = ["sudo bash $HOME/dcos_generate_config.sh",
              "docker run -d -p 4040:80 -v $HOME/genconf/serve:/usr/share/nginx/html:ro nginx 2>/dev/null",
              "docker run -d -p 2181:2181 -p 2888:2888 -p 3888:3888 --name=dcos_int_zk jplock/zookeeper 2>/dev/null"
              ]
  }
}

resource "scaleway_server" "dcos_master" {
  name = "${format("${var.dcos_cluster_name}-master-%02d", count.index)}"
  image = "${var.base_image_id}"
  dynamic_ip_required = "${var.dynamic_ip}"
  type = "${var.scaleway_master_type}"
  count = "${var.dcos_master_count}"
  connection {
    user = "${var.user}"
    private_key = "${file(var.dcos_ssh_key_path)}"
  }
  provisioner "local-exec" {
    command = "rm -rf ./scw-install.sh"
  }
  provisioner "local-exec" {
    command = "echo ${format("MASTER_%02d", count.index)}=\"${self.public_ip}\" >> ips.txt"
  }
  provisioner "local-exec" {
    command = "while [ ! -f ./scw-install.sh ]; do sleep 1; done"
  }
  provisioner "file" {
    source = "./scw-install.sh"
    destination = "/tmp/scw-install.sh"
  }
  provisioner "remote-exec" {
    inline = "bash /tmp/scw-install.sh master"
  }
}

resource "scaleway_server" "dcos_agent" {
  name = "${format("${var.dcos_cluster_name}-agent-%02d", count.index)}"
  depends_on = ["scaleway_server.dcos_bootstrap"]
  image = "${var.base_image_id}"
  dynamic_ip_required = "${var.dynamic_ip}"
  type = "${var.scaleway_agent_type}"
  count = "${var.dcos_agent_count}"
  connection {
    user = "${var.user}"
    private_key = "${file(var.dcos_ssh_key_path)}"
  }
  provisioner "local-exec" {
    command = "while [ ! -f ./scw-install.sh ]; do sleep 1; done"
  }
  provisioner "file" {
    source = "scw-install.sh"
    destination = "/tmp/scw-install.sh"
  }
  provisioner "remote-exec" {
    inline = "bash /tmp/scw-install.sh slave"
  }
}


resource "scaleway_server" "dcos_public_agent" {
  name = "${format("${var.dcos_cluster_name}-public-agent-%02d", count.index)}"
  depends_on = ["scaleway_server.dcos_bootstrap"]
  image = "${var.base_image_id}"
  dynamic_ip_required = "${var.dynamic_ip}"
  type = "${var.scaleway_agent_type}"
  connection {
    user = "${var.user}"
    private_key = "${file(var.dcos_ssh_key_path)}"
  }
  provisioner "local-exec" {
    command = "while [ ! -f ./scw-install.sh ]; do sleep 1; done"
  }
  provisioner "file" {
    source = "scw-install.sh"
    destination = "/tmp/scw-install.sh"
  }
  provisioner "remote-exec" {
    inline = "bash /tmp/scw-install.sh slave_public"
  }
}
