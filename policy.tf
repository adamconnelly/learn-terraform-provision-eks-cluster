locals {
  plan_policies = [
    "k8s_labels_policy",
  ]
}

resource "spacelift_policy" "plan" {
  for_each = toset(local.plan_policies)
  name     = each.key
  body     = file("policies/${each.key}.rego")
  type     = "PLAN"
}
