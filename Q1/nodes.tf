provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "ml_cluster" {
  name     = var.cluster_name
  location = var.region
  node_locations = [var.zone]
  remove_default_node_pool = false
  initial_node_count = 1
}

resource "google_container_node_pool" "gpunodepool" {
  name       = google_container_cluster.ml_cluster.name
  location   = var.region
  cluster    = google_container_cluster.ml_cluster.name
  node_count = 3

  autoscaling {
    total_min_node_count = "1"
    total_max_node_count = "5"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }
	
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    labels = {
      env = var.project_id
    }

    guest_accelerator {
      type  = var.gpu_type
      count = 1
      gpu_driver_installation_config {
        gpu_driver_version = var.gpu_driver_version
      }
    }

    image_type   = "cos_containerd"
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]

    disk_size_gb = "30"
    disk_type    = "pd-standard"

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
  
}  
