# Purpose

Follow the steps in this document, which leverage the scripts in this repo,
to set up an Apigee X instance on Google Cloud for demonstration purposes. 

The steps are broken up into a few different scripts to allow for a variety
of more or less complex installations and options.

# Getting Started

## Make the script executable
```
chmod +x demo
```
## Provision the Apigee Org/Instance
```
gcloud config set project my-project
./demo provision --network=default --region=us-central1
 
```
## Confirm new instance and show access details
```
./demo describe
```
## Test access to Apigee from inside the private network
```
./demo test-internal-access --network=default
```

# Configure Public Internet Access
```
./demo setup-external-access --network=default --domain={IP-ADDRESS}.nip.io
```