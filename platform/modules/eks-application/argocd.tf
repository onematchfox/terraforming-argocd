resource "argocd_application" "this" {
  metadata {
    name      = local.full_name
    namespace = "argocd"
    labels    = local.common_labels
  }

  spec {
    project = var.argocd_project

    source {
      repo_url        = var.source_repo_url
      path            = var.source_path
      target_revision = var.source_target_revision
      helm {
        release_name = var.service

        parameter {
          name  = "replicaCount"
          value = var.replica_count
        }

        values = yamlencode(local.helm_values)
      }
    }

    destination {
      server    = coalesce(var.destination_server, "https://kubernetes.default.svc")
      namespace = coalesce(var.destination_namespace, var.service)
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = [
        "ApplyOutOfSyncOnly=true",
        "CreateNamespace=true"
      ]
    }
  }
}
