#!/usr/bin/env bash

INSTANCE_PROFILE_PREFIX=$(aws cloudformation describe-stacks \
  | jq -r '.Stacks[].StackName' \
  | grep eksctl-eksworkshop-eksctl-nodegroup)

INSTANCE_PROFILE_NAME=$(aws iam list-instance-profiles \
  | jq -r '.InstanceProfiles[].InstanceProfileName' \
  | grep $INSTANCE_PROFILE_PREFIX)

ROLE_NAME=$(aws iam get-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME \
  | jq -r '.InstanceProfile.Roles[] | .RoleName')

mkdir ./iam_policy
cat <<EoF > ./iam_policy/k8s-logs-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EoF
aws iam put-role-policy \
  --role-name $ROLE_NAME \
  --policy-name Logs-Policy-For-Worker \
  --policy-document file://./iam_policy/k8s-logs-policy.json

aws iam get-role-policy \
  --role-name $ROLE_NAME \
  --policy-name Logs-Policy-For-Worker

ACCESS_POLICIES='{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":["*"]},"Action":["es:*"],"Resource":"*"}]}'

aws es create-elasticsearch-domain \
  --domain-name kubernetes-logs \
  --elasticsearch-version 6.3 \
  --elasticsearch-cluster-config \
  InstanceType=m4.large.elasticsearch,InstanceCount=2 \
  --ebs-options EBSEnabled=true,VolumeType=standard,VolumeSize=100 \
  --access-policies $ACCESS_POLICIES

aws es describe-elasticsearch-domain \
  --domain-name kubernetes-logs \
  --query 'DomainStatus.Processing'

kubectl apply -f fluentd.yml

cat <<EoF > ./lambda.json
{
   "Version": "2012-10-17",
   "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
        "Service": "lambda.amazonaws.com"
     },
   "Action": "sts:AssumeRole"
   }
 ]
}
EoF
aws iam create-role \
  --role-name lambda_basic_execution \
  --assume-role-policy-document file://./lambda.json

aws iam attach-role-policy \
  --role-name lambda_basic_execution \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

