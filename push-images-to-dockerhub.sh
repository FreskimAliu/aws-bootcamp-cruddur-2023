#!/bin/bash

# Log in to Docker Hub
docker login

# Generate a timestamp for the tag
TAG=$(date +%Y%m%d%H%M%S)

# Get the images created by the Docker Compose file and loop over them
for IMAGE in $(docker-compose images -q); do
  # Get the repository and tag of the image
  REPO=$(docker inspect --format='{{index .RepoTags 0}}' $IMAGE | cut -d: -f1)

  # Tag the image with the repository and tag that you want to use on Docker Hub
  docker tag $IMAGE $REPO:$TAG
  docker tag $IMAGE $REPO:latest

  # Push the tagged image to Docker Hub
  docker push $REPO:$TAG
  docker push $REPO:latest
done
