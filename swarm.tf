resource "digitalocean_droplet" "manager" {
  name   = "manager"
  image  = "${var.image}"
  region = "${var.region}"
  size   = "${var.size_cluster}"

  private_networking = true

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    user        = "${var.connection_user}"
    type        = "${var.connection_type}"
    private_key = "${file(var.pvt_key)}"
    timeout     = "${var.connection_timeout}"
  }

  provisioner "file" {
    source      = "swarm/init-manager.sh"
    destination = "/tmp/init.sh"
  }

  provisioner "file" {
    source      = "swarm/config"
    destination = "/tmp/swarm"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh ${digitalocean_droplet.manager.ipv4_address_private} ${digitalocean_droplet.worker1.ipv4_address_private} ${digitalocean_droplet.worker2.ipv4_address_private}",
    ]
  }
}

resource "digitalocean_droplet" "worker1" {
  name   = "worker1"
  image  = "${var.image}"
  region = "${var.region}"
  size   = "${var.size_cluster}"

  private_networking = true

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    user        = "${var.connection_user}"
    type        = "${var.connection_type}"
    private_key = "${file(var.pvt_key)}"
    timeout     = "${var.connection_timeout}"
  }

  provisioner "file" {
    source      = "swarm/init-worker.sh"
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
    ]
  }
}

resource "digitalocean_droplet" "worker2" {
  name   = "worker2"
  image  = "${var.image}"
  region = "${var.region}"
  size   = "${var.size_cluster}"

  private_networking = true

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    user        = "${var.connection_user}"
    type        = "${var.connection_type}"
    private_key = "${file(var.pvt_key)}"
    timeout     = "${var.connection_timeout}"
  }

  provisioner "file" {
    source      = "swarm/init-worker.sh"
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
    ]
  }
}

resource "digitalocean_floating_ip" "manager" {
  droplet_id = "${digitalocean_droplet.manager.id}"
  region     = "${digitalocean_droplet.manager.region}"
}
