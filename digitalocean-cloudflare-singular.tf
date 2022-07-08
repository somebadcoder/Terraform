terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.17.0"
    }
  }
}
provider "digitalocean" {
  token = ""
}
provider "cloudflare" {
  api_token = ""
  # Configuration options
}

resource "digitalocean_droplet" "musicdroplet" {
  image  = "ubuntu-18-04-x64"
  name   = "music"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
}

resource "cloudflare_record" "musicdns" {
  zone_id = ""
  name    = "music"
  value   = digitalocean_droplet.music.ipv4_address
  type    = "A"
  ttl     = 3600
}
