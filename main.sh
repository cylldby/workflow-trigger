#!/usr/bin/env bash

# Store Eventarc JSON description into variable PAYLOAD
read -n$HTTP_CONTENT_LENGTH PAYLOAD;

# Extract information about bucket and uploaded object from PAYLOAD
MESSAGE=$(echo $PAYLOAD | 
        jq -r '.protoPayload.resourceName' | \
        awk '{split($0,a,"/"); print "The object "a[6]" has been added to the bucket "a[4]}')
DATA='{"message":"'$MESSAGE'"}'

# Trigger the execution of the workflow, with the desired information
gcloud workflows execute --location asia-southeast1 sample_workflow --data="$DATA"