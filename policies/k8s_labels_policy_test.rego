package spacelift

test_deny_all_tags_missing_deployment {
  expected := { "resource \"deployment.apps/worker-pool\" does not have all required labels (app.kubernetes.io/name, app.kubernetes.io/instance, app.kubernetes.io/version)" }
  deny == expected with input as {
    "kubernetes": {
      "items": [{
        "after": {
          "apiVersion": "apps/v1",
          "kind": "Deployment",
          "metadata": {
            "labels": {
              "spacelift-stack": "worker-dev"
            },
            "name": "worker-pool",
            "namespace": "spacelift-worker-dev"
          }
        },
        "before": {
        },
        "id": "deployment.apps/worker-pool",
        "operation": "configured"
      }]
    }
  }
}

test_allow_no_tags_missing_deployment {
  expected := set()
  deny == expected with input as {
    "kubernetes": {
      "items": [{
        "after": {
          "apiVersion": "apps/v1",
          "kind": "Deployment",
          "metadata": {
            "labels": {
              "app.kubernetes.io/instance": "dev",
              "app.kubernetes.io/name": "worker-pool",
              "app.kubernetes.io/version": "latest",
              "spacelift-stack": "worker-dev"
            },
            "name": "worker-pool",
            "namespace": "spacelift-worker-dev"
          }
        },
        "before": {
        },
        "id": "deployment.apps/worker-pool",
        "operation": "configured"
      }]
    }
  }
}

test_allow_some_tags_missing_deployment {
  expected := { "resource \"deployment.apps/worker-pool\" does not have all required labels (app.kubernetes.io/instance, app.kubernetes.io/version)" }
  deny == expected with input as {
    "kubernetes": {
      "items": [{
        "after": {
          "apiVersion": "apps/v1",
          "kind": "Deployment",
          "metadata": {
            "labels": {
              "app.kubernetes.io/name": "worker-pool",
              "spacelift-stack": "worker-dev"
            },
            "name": "worker-pool",
            "namespace": "spacelift-worker-dev"
          }
        },
        "before": {
        },
        "id": "deployment.apps/worker-pool",
        "operation": "configured"
      }]
    }
  }
}

test_deny_secret_missing_required_labels {
  expected := { "resource \"secret/worker-pool-credentials-2tkdbf28b7\" does not have all required labels (app.kubernetes.io/name, app.kubernetes.io/instance, app.kubernetes.io/version)" }
  deny == expected with input as {
    "kubernetes": {
      "items": [{
        "after": {
          "apiVersion": "v1",
          "data": {
            "WORKER_POOL_PK": "d196dab5",
            "WORKER_POOL_TOKEN": "a62f9248"
          },
          "kind": "Secret",
          "metadata": {
            "annotations": {
              "kubectl.kubernetes.io/last-applied-configuration": "abc92d9d"
            },
            "creationTimestamp": "2022-03-10T17:02:26Z",
            "labels": {
              "spacelift-stack": "worker-dev"
            },
            "name": "worker-pool-credentials-2tkdbf28b7",
            "namespace": "spacelift-worker-dev",
            "resourceVersion": "182659",
            "uid": "2508136c-7dc2-4a78-b83e-ea406ba07ae5"
          },
          "type": "Opaque"
        },
        "before": {},
        "id": "secret/worker-pool-credentials-2tkdbf28b7",
        "operation": "configured"
      }]
    }
  }
}
