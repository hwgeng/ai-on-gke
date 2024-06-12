# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
data "google_project" "project" {
  project_id = var.project_id
}

# Retrieve an access token as the Terraform runner.
data "google_client_config" "provider" {
  provider = google
}

# Point to the created cluster.
data "google_container_cluster" "my_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}

provider "kubectl" {
  host                   = "https://${google_container_cluster.main.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.main.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
  load_config_file       = false
}

/** Creating Secrets to initialize the various Supported LLMs. **/
resource "kubernetes_secret" "secret_google_api" {
  metadata {
    name = "secret-google-api"
    #namespace = var.namespace
    labels = {
      "sensitive" = "true"
      "app"       = var.application_name
    }
  }
  data = {
    "${var.secret_google_api_key}" = var.GOOGLE_API_KEY_VALUE
  }
}
resource "kubernetes_secret" "secret_openapi_api" {
  metadata {
    name = "secret-openapi-api"
    #namespace = var.namespace
    labels = {
      "sensitive" = "true"
      "app"       = var.application_name
    }
  }
  data = {
    "${var.secret_openapi_api_key}" = var.OPENAI_API_KEY_VALUE
  }
}
resource "kubernetes_secret" "secret_hf_api" {
  metadata {
    name = "secret-hf-api"
    #namespace = var.namespace
    labels = {
      "sensitive" = "true"
      "app"       = var.application_name
    }
  }
  data = {
    "${var.secret_hf_api_key}" = var.HUGGINFACEHUB_API_TOKEN_VALUE
  }
}

resource "google_compute_address" "gke-static-ip-address" {
  name    = "gke-static-ip-address"
  project = var.project_id
  region  = var.region
}

/* Exposing the workload as a Service. */
resource "kubernetes_service" "gke_rag_langchain_service" {

  metadata {
    name = "rag-langchain-application-service"
    #namespace = var.namespace
  }
  spec {
    selector = {
      app = var.gke_workload_name
    }

    port {
      port        = 80
      target_port = 80
    }

    type             = "NodePort"
    load_balancer_ip = google_compute_address.gke-static-ip-address.address

  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
    ]
  }

  #depends_on = [time_sleep.wait_service_cleanup]
}

/* deploying the image as a GKE Workload. */
resource "kubernetes_deployment" "gke_rag_langchain_workload" {

  metadata {
    name = var.gke_workload_name
    #namespace = var.namespace
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.gke_workload_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.gke_workload_name
        }
      }

      spec {
        container {
          image = var.application_docker_image
          name  = var.gke_workload_name

          port {
            container_port = "80"
          }

          env {
            name  = "PORT"
            value = "80"
          }

          env {
            name = var.secret_google_api_key
            value_from {
              secret_key_ref {
                name = kubernetes_secret.secret_google_api.metadata[0].name
                key  = var.secret_google_api_key
              }
            }
          }

          env {
            name = var.secret_openapi_api_key
            value_from {
              secret_key_ref {
                name = kubernetes_secret.secret_openapi_api.metadata[0].name
                key  = var.secret_openapi_api_key
              }
            }
          }

          env {
            name = var.secret_hf_api_key
            value_from {
              secret_key_ref {
                name = kubernetes_secret.secret_hf_api.metadata[0].name
                key  = var.secret_hf_api_key
              }
            }
          }

          resources {
            limits = {
              cpu               = "500m"
              memory            = "2Gi"
              ephemeral-storage = "1Gi"
            }
            requests = {
              cpu               = "500m"
              memory            = "2Gi"
              ephemeral-storage = "1Gi"
            }
          }
          
        }

      }
    }
  }
}