#!/bin/bash

# Configuración
PROFILE="devops-training-2025"
REGION="eu-west-1"
REPO_NAME="java-webapp-repo"
IMAGE_NAME="contrerasadr/devops-training-2025-java-app"
TAG="0.0.1-SNAPSHOT"

# Obtener ID de cuenta AWS
ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE --query Account --output text)

# Login en ECR
aws ecr get-login-password --region $REGION --profile $PROFILE | \
docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Construir imagen
#docker build -t $IMAGE_NAME .

# Etiquetar imagen
docker tag $IMAGE_NAME:$TAG $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$TAG

# Subir a ECR
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$TAG

echo "Imagen subida correctamente a ECR: $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$TAG"
