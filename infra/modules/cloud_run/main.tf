resource "google_cloud_run_service" "default" {
  name     = var.name
  project  = var.project_id
  location = var.location

  template {
    spec {
      containers {
        image = "gcr.io/cloud-builders/docker"
      }
      service_account_name = var.service_account_email
    }
  }

  lifecycle {
    ignore_changes = [
      # gcloudからデプロイしたとき、以下のパラメータが入る。変更差分として判定したくないのでチェック対象から外す
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
      # Clour Buildからビルド・デプロイしたとき、以下のパラメータが入る。変更差分として判定したくないのでチェック対象から外す
      template[0].metadata[0].labels,
      template[0].spec[0].containers["image"]
    ]
  }

}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}