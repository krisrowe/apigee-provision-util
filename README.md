# Purpose

Follow the steps in this document, which leverage the scripts in this repo,
to set up an Apigee X instance on Google Cloud for demonstration purposes. 

The steps are broken up into a few different scripts to allow for a variety
of more or less complex installations and options.

# Getting Started

## Prepare settings
Open the [settings.json](settings.json) file and provide your project ID and network name.
```
{
 "project": "apigee-123456",
 "network": "demo-net"
}
```

## Create an Apigee Instance
```
chmod +x create-apigee-instance
./create-apigee-instance
```

## Configure Public Internet Access
```
chmod +x setup-external-access
./setup-external-access
```