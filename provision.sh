if [[ -z "${PROJECT_ID}" ]]; then
    echo "Must set PROJECT_ID environment variable first."
    exit 1
fi 

export AUTH="Authorization: Bearer $(gcloud auth print-access-token)"
export RUNTIME_LOCATION="us-central1"
export ANALYTICS_REGION=$RUNTIME_LOCATION

gcloud services enable apigee.googleapis.com \
  servicenetworking.googleapis.com compute.googleapis.com \
  cloudkms.googleapis.com --project=$PROJECT_ID

export RANGE_NAME=google-svcs
export NETWORK_NAME=demonet

export CONFIRM=$(gcloud compute networks list --project=$PROJECT_ID --format="value(name)" --filter="name:${NETWORK_NAME}")
if [[ -z "${CONFIRM}" ]]; then
  echo "Provisioning a network."
  gcloud compute networks create demonet --project=$PROJECT_ID
else
  echo "Network previously provisioned."
fi

export CONFIRM=$(gcloud compute addresses list --project=$PROJECT_ID --format="value(name)" --filter="name:${RANGE_NAME}")
if [[ -z "${CONFIRM}" ]]; then
  echo "Provisioning a peering address range without specifying addresses. Use --addresses instead to specify."
  gcloud compute addresses create $RANGE_NAME \
    --global \
    --prefix-length=21 \
    --description="Peering range for Apigee services" \
    --network=$NETWORK_NAME \
    --purpose=VPC_PEERING \
    --project=$PROJECT_ID
else
  echo "Peering range previously reserved."
fi


export CONFIRM=$(gcloud compute addresses list --project=$PROJECT_ID --format="value(name)" --filter="name:google-managed-services-support-1")
if [[ -z "${CONFIRM}" ]]; then
  gcloud compute addresses create google-managed-services-support-1 \
    --global \
    --prefix-length=28 \
    --description="Peering range for supporting Apigee services" \
    --network=$NETWORK_NAME \
    --purpose=VPC_PEERING \
    --project=$PROJECT_ID
else
  echo "Support range previously created."
fi
