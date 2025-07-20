#!/bin/bash
aws ec2 run-instances \
    --image-id ami-xxxxx \
    --count 1 \
    --instance-type t2.micro \
    --key-name my-key \
    --security-groups my-security-group \
    --region eu-north-1
