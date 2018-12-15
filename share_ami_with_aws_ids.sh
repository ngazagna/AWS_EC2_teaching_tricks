#!/bin/sh

while read p; do
  echo "$p"
  aws ec2 modify-image-attribute --image-id your-ami-id --launch-permission "Add=[{UserId=$p}]" --region your-region
done <$1
