/*
resource "digitalocean_droplet" "mywebserver" {
  // See Document https://developers.digitalocean.com/documentation/v2/#list-all-keys
  ssh_keys           = [12345678]
  image              = var.ubuntu
  region             = var.do_ams3
  size               = "s-1vcpu-1gb"
  private_networking = true
  backups            = true
  ipv6               = true
  name               = "mywebserver-ams3"

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
    ]

    connection {
      type     = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user     = "root"
      timeout  = "2m"
    }
  }
}

resource "digitalocean_domain" "mywebserver" {
  name       = "www.mywebserver.com"
  ip_address = digitalocean_droplet.mywebserver.ipv4_address
}

resource "digitalocean_record" "mywebserver" {
  domain = digitalocean_domain.mywebserver.name
  type   = "A"
  name   = "mywebserver"
  value  = digitalocean_droplet.mywebserver.ipv4_address
}
*/