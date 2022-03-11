package spacelift

required_labels := {
  "app.kubernetes.io/name",
  "app.kubernetes.io/instance",
  "app.kubernetes.io/version"
}

deny[sprintf("resource %q does not have all required labels (%s)", [resource.id, concat(", ", missing_labels)])] {
  resource := input.kubernetes.items[_]
  labels := resource.after.metadata.labels
  missing_labels := { label | required_labels[label]; not labels[label] }

  count(missing_labels) > 0
}

sample { true }
