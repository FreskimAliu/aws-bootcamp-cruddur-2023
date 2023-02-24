#!/bin/bash

docker login

# Generate a timestamp for the tag
tag=$(date +%Y%m%d%H%M%S)

dockerhub_username='freskimaliu'
frontend_image='aws-bootcamp-cruddur-2023-frontend-react-js'
backend_image='aws-bootcamp-cruddur-2023-backend-flask'

# Tag and push frontend image
echo "Tagging and pushing ${frontend_image}"
docker tag $frontend_image:latest $dockerhub_username/$frontend_image:$tag
docker tag $frontend_image:latest $dockerhub_username/$frontend_image:latest

docker push $dockerhub_username/$frontend_image:$tag
docker push $dockerhub_username/$frontend_image:latest

# Tag and push backend image
echo "Tagging and pushing ${backend_image}"
docker tag $backend_image:latest $dockerhub_username/$backend_image:$tag
docker tag $backend_image:latest $dockerhub_username/$backend_image:latest

docker push $dockerhub_username/$backend_image:$tag
docker push $dockerhub_username/$backend_image:latest
