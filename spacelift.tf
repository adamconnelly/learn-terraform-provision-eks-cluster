resource "spacelift_context" "k8s-testing" {
  description = "A context containing info about the EKS test cluster"
  name        = "EKS Cluster Config"
}

resource "spacelift_environment_variable" "eks_cluster_name" {
  context_id = spacelift_context.k8s-testing.id
  name       = "EKS_CLUSTER_NAME"
  value      = local.cluster_name
  write_only = false
}

resource "spacelift_environment_variable" "eks_region" {
  context_id = spacelift_context.k8s-testing.id
  name       = "EKS_REGION"
  value      = var.region
  write_only = false
}
