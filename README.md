# Purpose

Follow the steps in this document, which leverage the scripts in this repo,
to set up an Apigee X instance on Google Cloud for demonstration purposes. 

The steps are broken up into a few different scripts to allow for a variety
of more or less complex installations and options.

# Getting Started

## Prep the Enironment

### Configure settings
Open the [settings.json](settings.json) file and provide your project ID and network name.
```
{
 "project": "apigee-123456",
 "network": "demo-net",
 "region": "us-central1"
}
```
### Make the script executable
```
chmod +x demo
```
## Create an Apigee Instance
```
./demo create-apigee-instance
```
## Confirm new instance and show access details
```
./demo describe
```
## Test access to Apigee from inside the private network
```
./demo test-internal-access
```

# Configure Public Internet Access
```
./demo setup-external-access
```