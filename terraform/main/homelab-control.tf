resource "digitalocean_droplet" "homelab-control" {
  image  = "191656570"
  name   = "homelab-control"
  region = "nyc3"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = var.pvt_key
    timeout     = "2m"
  }


  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo hostname homelab-control",
    ]
  }
}