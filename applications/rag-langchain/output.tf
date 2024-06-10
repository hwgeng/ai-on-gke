output "deployment_name" {
  value = kubernetes_deployment.gke_rag_langchain_workload.metadata[0].name
}

output "container_name" {
  value = kubernetes_deployment.gke_rag_langchain_workload.spec[0].template[0].spec[0].container[0].name
}

output "container_image" {
  value = kubernetes_deployment.gke_rag_langchain_workload.spec[0].template[0].spec[0].container[0].image
}