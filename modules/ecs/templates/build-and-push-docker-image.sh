#!/bin/bash
APP=$1
ENV=$2
REGION=$3
REPO_URL=$4
HEALTHCHECK_PATH=$5
HEALTHCHECK_PORT=$6

docker build --build-arg health_check_path=$HEALTHCHECK_PATH --build-arg health_check_port=$HEALTHCHECK_PORT . -t $ENV-ecs-$APP:latest
eval $(aws ecr get-login --no-include-email --region $REGION --profile $ENV)
docker tag $ENV-ecs-$APP:latest $REPO_URL:latest
docker push $REPO_URL:latest
