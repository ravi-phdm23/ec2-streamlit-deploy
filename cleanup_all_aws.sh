#!/bin/bash

# List all AWS regions
REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

echo "======================"
echo "🔍 Checking EC2 Instances in All Regions"
echo "======================"

for REGION in $REGIONS; do
  echo -e "\n📍 Region: $REGION"
  INSTANCES=$(aws ec2 describe-instances --region "$REGION" \
    --query "Reservations[].Instances[].InstanceId" --output text)

  if [ -n "$INSTANCES" ]; then
    echo "⚠️  Instances found: $INSTANCES"
  else
    echo "✅ No instances found."
  fi

done

echo "\n======================"
echo "🧹 Cleaning up ALL EC2 instances, security groups, EIPs, volumes, AMIs, key pairs, and S3 buckets"
echo "======================"

for REGION in $REGIONS; do
  echo -e "\n🌍 Processing region: $REGION"

  # Terminate all instances
  INSTANCE_IDS=$(aws ec2 describe-instances --region "$REGION" --query "Reservations[].Instances[].InstanceId" --output text)
  if [ -n "$INSTANCE_IDS" ]; then
    echo "🛑 Terminating instances: $INSTANCE_IDS"
    aws ec2 terminate-instances --instance-ids $INSTANCE_IDS --region "$REGION"
    aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS --region "$REGION" 2>/dev/null
  fi

  # Delete all non-default security groups
  SG_IDS=$(aws ec2 describe-security-groups --region "$REGION" \
    --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)
  for SG_ID in $SG_IDS; do
    echo "❌ Deleting security group: $SG_ID"
    aws ec2 delete-security-group --group-id "$SG_ID" --region "$REGION"
  done

  # Release all Elastic IPs
  ALLOC_IDS=$(aws ec2 describe-addresses --region "$REGION" --query "Addresses[].AllocationId" --output text)
  for ALLOC_ID in $ALLOC_IDS; do
    echo "💥 Releasing Elastic IP: $ALLOC_ID"
    aws ec2 release-address --allocation-id "$ALLOC_ID" --region "$REGION"
  done

  # Delete all volumes not in-use
  VOLUME_IDS=$(aws ec2 describe-volumes --region "$REGION" \
    --query "Volumes[?State=='available'].VolumeId" --output text)
  for VOL_ID in $VOLUME_IDS; do
    echo "🧨 Deleting volume: $VOL_ID"
    aws ec2 delete-volume --volume-id "$VOL_ID" --region "$REGION"
  done

  # Deregister all AMIs
  IMAGE_IDS=$(aws ec2 describe-images --region "$REGION" --owners self --query "Images[].ImageId" --output text)
  for IMG_ID in $IMAGE_IDS; do
    echo "🖼️ Deregistering AMI: $IMG_ID"
    aws ec2 deregister-image --image-id "$IMG_ID" --region "$REGION"
  done

  # Delete all key pairs
  KEY_NAMES=$(aws ec2 describe-key-pairs --region "$REGION" --query "KeyPairs[].KeyName" --output text)
  for KEY in $KEY_NAMES; do
    echo "🗝️ Deleting key pair: $KEY"
    aws ec2 delete-key-pair --key-name "$KEY" --region "$REGION"
  done

  # Delete all S3 buckets
  BUCKETS=$(aws s3api list-buckets --query "Buckets[].Name" --output text)
  for BUCKET in $BUCKETS; do
    REGION_MATCH=$(aws s3api get-bucket-location --bucket "$BUCKET" --query "LocationConstraint" --output text)
    REGION_MATCH=${REGION_MATCH:-us-east-1}  # default if null
    if [ "$REGION" == "$REGION_MATCH" ]; then
      echo "🗑️ Deleting contents and bucket: $BUCKET"
      aws s3 rm s3://$BUCKET --recursive
      aws s3api delete-bucket --bucket "$BUCKET" --region "$REGION"
    fi
  done

done

echo -e "\n✅ Full AWS cleanup completed across all regions."