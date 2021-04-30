OPERATOR_NAME=bucket-maker
REGION=asia-southeast1

GCLOUD_PROJECT := $(shell gcloud config get-value project)
PROJECT_NUMBER := $(shell gcloud projects list --filter="${GCLOUD_PROJECT}" --format="value(PROJECT_NUMBER)")
GCLOUD_DOCKER_URL=gcr.io/$(GCLOUD_PROJECT)/$(OPERATOR_NAME)

BUCKET_NAME := $(shell gcloud config get-value project)
TRIGGER_NAME=upload2gcs

build:
	gcloud builds submit \
		--project "${GCLOUD_PROJECT}" \
		--tag "$(GCLOUD_DOCKER_URL)" \
		.

create_trigger:
	gcloud eventarc triggers create "${TRIGGER_NAME}" \
		--location="${REGION}" \
		--destination-run-service="${OPERATOR_NAME}"  \
		--event-filters="type=google.cloud.audit.log.v1.written" \
		--event-filters="methodName=storage.objects.create" \
		--event-filters="serviceName=storage.googleapis.com" \
		--service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com

deploy: build
	gcloud run deploy "$(OPERATOR_NAME)" \
		--quiet \
		--project "$(GCLOUD_PROJECT)" \
		--region "$(REGION)" \
		--image "$(GCLOUD_DOCKER_URL)" \
		--platform "managed"

	create_trigger