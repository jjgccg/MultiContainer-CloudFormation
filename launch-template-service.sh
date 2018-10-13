#!/bin/bash
# Creates a custom service and task definition with up to 5 container
# definitions for the primary AWS stack infrastructure

if [ ! -f ./deployment.properties ]; then
    echo "The deployment.properties file does not exist!"
    exit 1
fi

# Read the deployment properties from the file.
. deployment.properties

if [ -z $1 ]; then
  echo "Please set a flag."
  echo "Available flags - --create/-c and --update/-c"
  exit 1
fi

echo
echo "--USAGE--"
echo "* This script is used for the custom deployment of a task *"
echo "*     definition with up to 5 container definitions.      *"
echo "---USAGE--"
echo

echo "CLI Profile: "
read CLI_PROFILE

ENVIRONMENT="$environment"
CUSTOMER="$customer"
APPLICATION="$application"
MANAGEMENT_STACK_NAME="$management_stack_name"
REGION="$region"

SERVICE_NAME=$service_name
SERVICE_CONTAINER_NAME=$service_container_name
SERVICE_CONTAINER_PORT=$service_container_port
CONTAINER_DEF_NUMBER=$container_def_number
CONTAINER_DEF_NAMES=$container_def_names
CONTAINER_DEF_VERS=$container_def_vers
CONTAINER_DEF_IMAGES=$container_def_images
CONTAINER_DEF_MEM=$container_def_mem
CONTAINER_DEF_LINKS=$container_def_links
CONTAINER_DEF_CONTAINER_PORTS=$container_def_container_ports
CONTAINER_DEF_HOST_PORTS=$container_def_host_ports
CONTAINER_DEF_PROTOCOLS=$container_def_protocols

SERVICE_STACK_NAME=$(echo "$MANAGEMENT_STACK_NAME-$SERVICE_NAME")
echo $SERVICE_STACK_NAME

ALB_TARGET_GROUP=$(aws ssm get-parameter --name $APPLICATION-$CUSTOMER-$ENVIRONMENT-alb-target-group --profile $CLI_PROFILE | jq '.Parameter.Value' | tr -d \")
echo $ALB_TARGET_GROUP
ECS_CLUSTER_ID=$(aws ssm get-parameter --name $APPLICATION-$CUSTOMER-$ENVIRONMENT-ecs-cluster-id --profile $CLI_PROFILE | jq '.Parameter.Value' | tr -d \")
echo $ECS_CLUSTER_ID
ECS_SERVICE_ROLE=$(aws ssm get-parameter --name $APPLICATION-$CUSTOMER-$ENVIRONMENT-ecs-service-role --profile $CLI_PROFILE | jq '.Parameter.Value' | tr -d \")
echo $ECS_SERVICE_ROLE
if [ $1 == "-c" ] || [ $1 == "--create" ]; then
    aws cloudformation create-stack \
      --stack-name "$SERVICE_STACK_NAME" \
      --template-url https://s3.amazonaws.com/$APPLICATION-$CUSTOMER-$ENVIRONMENT/deployment/cloudformation-templates/template-environment-service.yml \
      --on-failure DO_NOTHING \
      --enable-termination-protection \
      --profile $CLI_PROFILE \
      --region $REGION \
      --timeout-in-minutes 180 \
      --parameters \
      ParameterKey=pEnvironment,ParameterValue="${ENVIRONMENT}" \
      ParameterKey=pCustomer,ParameterValue="${CUSTOMER}" \
      ParameterKey=pApplicationName,ParameterValue="${APPLICATION}" \
      ParameterKey=pECSServiceContainerName,ParameterValue="${SERVICE_CONTAINER_NAME}" \
      ParameterKey=pECSServiceContainerPort,ParameterValue="${SERVICE_CONTAINER_PORT}" \
      ParameterKey=pServiceName,ParameterValue="${SERVICE_NAME}" \
      ParameterKey=pContainerDefNum,ParameterValue="${CONTAINER_DEF_NUMBER}" \
      ParameterKey=pContainerDefNames,ParameterValue="${CONTAINER_DEF_NAMES}" \
      ParameterKey=pContainerDefVersions,ParameterValue="${CONTAINER_DEF_VERS}" \
      ParameterKey=pContainerDefMemory,ParameterValue="${CONTAINER_DEF_MEM}" \
      ParameterKey=pContainerDefLinks,ParameterValue="${CONTAINER_DEF_LINKS}" \
      ParameterKey=pContainerDefContainerPorts,ParameterValue="${CONTAINER_DEF_CONTAINER_PORTS}" \
      ParameterKey=pContainerDefHostPorts,ParameterValue="${CONTAINER_DEF_HOST_PORTS}" \
      ParameterKey=pContainerDefProtocol,ParameterValue="${CONTAINER_DEF_PROTOCOLS}" \
      ParameterKey=pECSCluster,ParameterValue="${ECS_CLUSTER_ID}" \
      ParameterKey=pECSServiceRole,ParameterValue="${ECS_SERVICE_ROLE}" \
      ParameterKey=pALBTargetGroup,ParameterValue="${ALB_TARGET_GROUP}" 
fi

if [ $1 == "-u" ] || [ $1 == "--update" ]; then
    aws cloudformation update-stack \
      --stack-name "$SERVICE_STACK_NAME" \
      --template-url https://s3.amazonaws.com/$APPLICATION-$CUSTOMER-$ENVIRONMENT/deployment/cloudformation-templates/template-environment-service.yml \
      --profile $CLI_PROFILE \
      --region $REGION \
      --parameters \
      ParameterKey=pEnvironment,ParameterValue="${ENVIRONMENT}" \
      ParameterKey=pCustomer,ParameterValue="${CUSTOMER}" \
      ParameterKey=pApplicationName,ParameterValue="${APPLICATION}" \
      ParameterKey=pECSServiceContainerName,ParameterValue="${SERVICE_CONTAINER_NAME}" \
      ParameterKey=pECSServiceContainerPort,ParameterValue="${SERVICE_CONTAINER_PORT}" \
      ParameterKey=pServiceName,ParameterValue="${SERVICE_NAME}" \
      ParameterKey=pContainerDefNum,ParameterValue="${CONTAINER_DEF_NUMBER}" \
      ParameterKey=pContainerDefNames,ParameterValue="${CONTAINER_DEF_NAMES}" \
      ParameterKey=pContainerDefVersions,ParameterValue="${CONTAINER_DEF_VERS}" \
      ParameterKey=pContainerDefMemory,ParameterValue="${CONTAINER_DEF_MEM}" \
      ParameterKey=pContainerDefLinks,ParameterValue="${CONTAINER_DEF_LINKS}" \
      ParameterKey=pContainerDefContainerPorts,ParameterValue="${CONTAINER_DEF_CONTAINER_PORTS}" \
      ParameterKey=pContainerDefHostPorts,ParameterValue="${CONTAINER_DEF_HOST_PORTS}" \
      ParameterKey=pContainerDefProtocol,ParameterValue="${CONTAINER_DEF_PROTOCOLS}" \
      ParameterKey=pECSCluster,ParameterValue="${ECS_CLUSTER_ID}" \
      ParameterKey=pECSServiceRole,ParameterValue="${ECS_SERVICE_ROLE}" \
      ParameterKey=pALBTargetGroup,ParameterValue="${ALB_TARGET_GROUP}" 
fi