provider "google" {
  credentials = file("fyra-app-firebase-admin-sdk-ifmcx-f92d825c61.json")
  project     = "fyra-app"
  region      = "europe-west1" # Change this to your desired region
}

resource "google_project" "project" {
  name       = "fyra-app"
  project_id = "fyra-app"
}

resource "google_firebase_project" "firebase_project" {
  project = google_project.project.project_id
}

resource "google_firebase_web_app" "web_app" {
  project = google_firebase_project.firebase_project.project_id
  display_name = "Fyra"
}

resource "google_firebase_hosting_site" "site" {
  project     = google_firebase_project.firebase_project.project_id
  site_config {
    site_name = "fyra-app"
  }
}

resource "google_firebase_hosting_release" "release" {
  site       = google_firebase_hosting_site.site.name
  version_config {
    version_name = "v1"
    config       = {
      "headers" = [{
        "source" => "**/*.@(jpg|jpeg|gif|png|js|css|html)",
        "headers" => [{
        "key"   => "Cache-Control",
        "value" => "public, max-age=31536000, immutable",
        }],
      }]
    }
  }
}
