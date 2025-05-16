provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance_template" "default" {
  name_prefix = "centos-mig-template-"
  region      = var.region

  properties {
    machine_type = "e2-micro"

    disks {
      auto_delete  = true
      boot         = true
      source_image = "centos-cloud/centos-stream-9"
    }

    network_interfaces {
      network = "default"
      access_config {}
    }

    metadata_startup_script = file("startup-script.sh")

    tags = ["http-server"]
  }
}

resource "google_compute_instance_group_manager" "default" {
  name               = "centos-apache-mig"
  base_instance_name = "centos-instance"
  zone               = var.zone
  version {
    instance_template = google_compute_instance_template.default.id
  }
  target_size = 2
}

resource "google_compute_firewall" "http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
