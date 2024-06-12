/** User Entered Values **/
variable "project_id" {
    default = "CHANGE_THIS"
 }
variable "region" {
  default = "CHANGE_THIS" /* example  - us-central1 */
}
variable "cluster_name" {
  type        = string
  default     = "CHANGE_THIS"
}

/** Application Variables **/

/** secrets for your LLM models. Keys will be entered when you run `terraform apply` **/
variable "secret_google_api_key" {
  default = "GOOGLE_API_KEY"
  type = string
}
variable "GOOGLE_API_KEY_VALUE" {
  sensitive   = true
}
variable "secret_openapi_api_key" {
  default = "OPENAI_API_KEY"
  type = string
}
variable "OPENAI_API_KEY_VALUE" {
  sensitive   = true
}
variable "secret_hf_api_key" {
  default = "HUGGINFACEHUB_API_TOKEN"
  type = string
}
variable "HUGGINFACEHUB_API_TOKEN_VALUE" {
  sensitive   = true
}
variable "namespace" {
  type        = string
  default     = "google-gke-rag-langchain"
}
variable "application_name" {
  type = string
  default = "rag-langchain-application"
}
variable "gke_workload_name" {
  type = string
  default = "rag-langchain-workload"
}
variable "application_docker_image" {
  type = string
  default = "us-central1-docker.pkg.dev/banded-advice-385820/google-star-hkth/google-star-hkth-gke:latest"
}
variable "application_workload_name" {
  type = string
  default = "google-gke-rag-langchain-workload"
}
variable "application_service_name" {
  type = string
  default = "us-central1-docker.pkg.dev/banded-advice-385820/google-star-hkth/google-star-hkth-gke:latest"
}
