set -e

SETTING_FOUND=$(cat settings.json | jq -r '.project')
if [[ -z "${SETTING_FOUND}" ]]; then
  if [[ -z "${PROJECT_ID}" ]]; then
    echo "Must set PROJECT_ID environment variable first."
    exit 1
  fi
  echo "Using PROJECT_ID environment variable."
else 
  # Overwrite the environment variable with what was found in settings.
  PROJECT_ID=${SETTING_FOUND}
  echo "Using project ID ${PROJECT_ID} as per settings."
fi

SETTING_FOUND=$(cat settings.json | jq -r '.network')
if [[ -z "${SETTING_FOUND}" ]]; then
  if [[ -z "${NETWORK_NAME}" ]]; then
    NETWORK_NAME=default
    echo "Using ${NETWORK_NAME} network by default."
  else 
    echo "Using ${NETWORK_NAME} network as per NETWORK_NAME environment variable."
  fi
else 
  # Overwrite the environment variable with what was found in settings.
  NETWORK_NAME=$SETTING_FOUND
  echo "Using ${NETWORK_NAME} network as per settings."
fi

SETTING_FOUND=$(cat settings.json | jq -r '.region')
if [[ -z "${SETTING_FOUND}" ]]; then
  if [[ -z "${REGION}" ]]; then
    RUNTIME_LOCATION=us-central1
    echo "Using ${RUNTIME_LOCATION} region by default."
  else 
    RUNTIME_LOCATION=$REGION
    echo "Using ${RUNTIME_LOCATION} region as per REGION environment variable."
  fi
else 
  # Overwrite the environment variable with what was found in settings.
  RUNTIME_LOCATION=$SETTING_FOUND
  echo "Using ${RUNTIME_LOCATION} region as per settings."
fi

export AUTH="Authorization: Bearer $(gcloud auth print-access-token)"
export ANALYTICS_REGION=$RUNTIME_LOCATION
