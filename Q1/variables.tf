variable "project_id" {
  default     = "neslihan-codeway"
  description = "the gcp_name_short project where GKE creates the cluster"
}

variable "region" {
  default     = "us-central1"
  description = "the gcp_name_short region where GKE creates the cluster"
}

variable "zone" {
  default     = "a"
  description = "the GPU nodes zone"
}

variable "cluster_name" {
  default     = "neslihan-codeway"
  description = "the name of the cluster"
}

variable "node_pool_name" {
  default     = "gpunodepool"
  description = "the name of the cluster"
}

variable "gpu_type" {
  default     = "nvidia-tesla-t4"
  description = "the GPU accelerator type"
}

variable "gpu_driver_version" {
  default = "LATEST"
  description = "the NVIDIA driver version to install"
}
