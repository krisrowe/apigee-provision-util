# Purpose

Follow the steps in this document, which leverage the scripts in this repo,
to set up an Apigee X instance on Google Cloud for demonstration purposes. 

The steps are broken up into a few different scripts to allow for a variety
of more or less complex installations and options.

# Getting Started

This utility is 100% pure shell script, so all you need to do is clone this repo and run it! 

## Make the script executable
```
chmod +x demo
```
## Provision the Apigee Org/Instance
### Run this
```
# Avoid having to put --project on every command below.
gcloud config set project my-project

# Do the actual provisioning.
./demo provision --network=default --region=us-central1
```
**NOTE**: You can safely run the above script as many times as you want. It will detect what has already been done and do only what's necessary! 
### Output
```
Enabling Google APIs...
Confirmed no Apigee organization exists for project my-org.
Provisioning a network...
Provisioning a /22 peering address range...
Provisioning a /28 peering address range...
Establishing VPC peering...

Creating an Apigee organization my-org:
- location: us-central1
- network: default
```

**NOTE:** The above kicks-off a long-running process of which you'll have to track the completion before proceeding to other commands.

## Confirm new instance and show access details
### Run this
```
./demo describe
```
### Output
```
*******************************************
*****     APIGEE INSTANCE DETAILS     *****
*******************************************
org: my-org
host name: my-org-eval.apigee.net
instance ip: 10.95.120.2
location: us-central1
*******************************************

Try the following from a machine instance inside project roweapi2301...

curl -k -H "Host: my-org-eval.apigee.net" "https://10.95.120.2/hello-world"

Or even easier, run this command: ./demo test-internal-access
```

## Test access to Apigee from inside the private network
### Run this
```
./demo test-internal-access --network=default
```
### Output
```
Testing internal access...

*******************************************
*****     APIGEE INSTANCE DETAILS     *****
*******************************************
org: my-org
host name: my-org-eval.apigee.net
instance ip: 10.95.120.2
location: us-central1
*******************************************

Creating temporary instance inside the VPC as a test client...
Giving some time for the new compute instance to become available for SSH...

Running the following command from the temporary instance inside the VPC.

curl -k -H "Host: my-org-eval.apigee.net" "https://10.95.120.2/hello-world"

API response as the output of above curl command: Hello, Guest!
Test result: success

Cleaning up...
```
### Another way to run it
If you include the `--keep-instance` flag, it will skip the cleanup step of deleting the client compute instance,
which will cause repeat execution to be quick, without having to wait on provisioning.
```
./demo test-internal-access --network=default --keep-instance
```
# Public Internet Access
## Setup
### Run this
```
./demo setup-external-access --network=default --domain={IP-ADDRESS}.nip.io
```
**NOTE**: You can safely run the above script as many times as you want. It will detect what has already been done and do only what's necessary! 
### Output
```
Setting up external access...

Checking details of the Apigee instance for project roweapi2301...

*******************************************
*****     APIGEE INSTANCE DETAILS     *****
*******************************************
org: my-org
host name: my-org-eval.apigee.net
instance ip: 10.95.120.2
location: us-central1
*******************************************

Provisioning NEG for PSC Target Service projects/la688d507488e3f3ap-tp/regions/us-central1/serviceAttachments/apigee-us-central1-sqx0.
Created [https://www.googleapis.com/compute/v1/projects/my-org/regions/us-central1/networkEndpointGroups/apigee].
Created network endpoint group [apigee].
External IP address previously reserved for load balancer.
Load balancer IP address: 10.95.120.0
Creating a backend service for the load balancer.
Creating the load balancer frontend...
Changing domain name configuration for Apigee instance from my-org-eval.apigee.net to 10.95.120.0.nip.io...
Provisioning SSL certificate...
Created [https://www.googleapis.com/compute/v1/projects/roweapi2301/global/sslCertificates/apigee].
NAME    TYPE     CREATION_TIMESTAMP             EXPIRE_TIME  MANAGED_STATUS
apigee  MANAGED  2023-01-25T07:26:59.696-08:00               PROVISIONING
    10.95.120.0.nip.io: PROVISIONING
Certificate provisioning can take up to an hour. Run this script again in a bit to see if it's done.
```
### Run this again after a bit
```
./demo setup-external-access --network=default --domain={IP-ADDRESS}.nip.io
```
### Output
```
Setting up external access...

Checking details of the Apigee instance for project roweapi2301...

*******************************************
*****     APIGEE INSTANCE DETAILS     *****
*******************************************
org: my-org
host name: 34.111.49.82.nip.io
instance ip: 10.95.120.2
location: us-central1
*******************************************

Network endpoint group (NEG) previously provisioned.
External IP address previously reserved for load balancer as apigee-lb.
Load balancer IP address: 34.111.49.82
Backend service previously created for the load balancer.
Load balancer frontend previously created.
Specified domain name matches existing Apigee environment group configuration. No change.
Creating the target HTTPS proxy...
Creating forwarding rule...
Attempting to invoke an API being managed by the Apigee instance...

curl -s https://34.111.49.82.nip.io/hello-world

API response: Hello, Guest!
```
## Undo External Access Configuration/Provisioning
This option could be handy if something goes so terribly wrong with the `setup-external-access` that it somehow cannot self-heal when run again, or if you just want to run that script again in full, for whatever reason, without skipping any steps that have previously been completed.
### Run this
```
./demo undo-external-access
```