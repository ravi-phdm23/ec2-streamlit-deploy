#!/bin/bash

# ------------- CONFIG -----------------
REGION="eu-north-1"  # Change this if your EC2s are in a different region

# ------------- TERMINATE ALL INSTANCES -----------------
echo "[INFO] Fetching all EC2 instance IDs..."
INSTANCE_IDS=$(aws ec2 describe-instances     --query "Reservations[].Instances[].InstanceId"     --output text --region "$REGION")

if [ -z "$INSTANCE_IDS" ]; then
  echo "[INFO] No instances found."
else
  echo "[INFO] Terminating EC2 instances: $INSTANCE_IDS"
  aws ec2 terminate-instances --instance-ids $INSTANCE_IDS --region "$REGION"

  echo "[INFO] Waiting for instances to terminate..."
  aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS --region "$REGION"
  echo "[SUCCESS] All instances terminated."
fi

# ------------- DELETE ALL NON-DEFAULT SECURITY GROUPS -----------------
echo "[INFO] Deleting all custom security groups..."

GROUP_IDS=$(aws ec2 describe-security-groups     --query "SecurityGroups[?GroupName!='default'].GroupId"     --output text --region "$REGION")

for GROUP_ID in $GROUP_IDS; do
  echo "[INFO] Deleting security group: $GROUP_ID"
  aws ec2 delete-security-group --group-id "$GROUP_ID" --region "$REGION"
done

echo "[SUCCESS] All non-default security groups deleted."

# ------------- DELETE ALL KEY PAIRS -----------------
echo "[INFO] Deleting all EC2 key pairs..."
KEY_NAMES=$(aws ec2 describe-key-pairs     --query "KeyPairs[].KeyName" --output text --region "$REGION")

for KEY_NAME in $KEY_NAMES; do
  echo "[INFO] Deleting key pair: $KEY_NAME"
  aws ec2 delete-key-pair --key-name "$KEY_NAME" --region "$REGION"
done

# ------------- DELETE LOCAL PEM FILES -----------------
echo "[INFO] Removing all .pem files from ~/.ssh/"
rm -f ~/.ssh/*.pem
echo "[SUCCESS] Local PEM files deleted."

echo "[COMPLETE] All EC2-related resources cleaned up in region: $REGION"
