SERVICE_ACCOUNT_NAME=workflows
PROJECT_ID := $(shell gcloud config get-value project)
WORKFLOW=sample_workflow
LOCATION=asia-southeast1

enable:
	gcloud services enable workflows.googleapis.com
	gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME}
	gcloud projects add-iam-policy-binding ${PROJECT_ID} \
		--member "serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
		--role "roles/logging.logWriter"

deploy:
	gcloud workflows deploy ${WORKFLOW} \
		--location=${LOCATION} \
		--source=${WORKFLOW}.yaml \
		--service-account=${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com