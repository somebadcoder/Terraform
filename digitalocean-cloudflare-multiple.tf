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

resource "digitalocean_droplet" "hydra" {
  image  = "ubuntu-20-04-x64"
  name   = "hydra-${count.index}"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  count  = 100
}

resource "cloudflare_record" "hydra" {
  count = length(digitalocean_droplet.hydra)
  name     = "hydra-${count.index}"
  type     = "A"
  proxied  = true
  ttl      = 1
  zone_id  = ""
  value = "${element(digitalocean_droplet.hydra.*.ipv4_address, count.index)}"
}




# If you wish to deploy k8 cluster, it can be done like this:
# resource "digitalocean_kubernetes_cluster" "k8-resource" {
#   name    = "k801"
#   region  = "nyc3"
#   version = "1.22.8-do.1"
#   node_pool {
#     name       = "pool01"
#     size       = "s-2vcpu-2gb"
#     node_count = 3
#   }
# }

# output "kube_config" {
#   value = digitalocean_kubernetes_cluster.k8-resource.kube_config
#   sensitive = true
# }
