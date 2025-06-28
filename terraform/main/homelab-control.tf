resource "digitalocean_droplet" "homelab-control" {
  image  = "191473488"
  name   = "homelab-control"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
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
      "nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs",
      "nix-channel --update",
      "nix-env -iA nixpkgs.git",
      "git clone https://github.com/metamageia/homelab.git ./.dotfiles",
      "cd ./.dotfiles",
      "echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf",
      "sudo systemctl restart nix-daemon.service || true",
      "nixos-rebuild switch --flake .#homelab-control",
    ]
  }
}