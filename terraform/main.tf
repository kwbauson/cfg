terraform {
  cloud {
    organization = "kwbauson"
    workspaces {
      name = "cfg"
    }
  }
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    porkbun = {
      source = "cullenmcdermott/porkbun"
    }
  }
}

provider "google" {
  project = "kwbauson"
  region  = "us-east1"
  zone    = "us-east1-a"
}
