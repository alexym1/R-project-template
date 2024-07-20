#!/bin/bash
ROOT_DIR=`git rev-parse --show-toplevel`
IMAGE_NAME="{{cookiecutter.project_slug}}"
CONTAINER_NAME= "{{cookiecutter.project_slug}}/_container"
VERSION=0.1.0
PORT=8000
GITHUB_REPOSITORY="your_github_username/{{cookiecutter.project_slug}}"
CR_PAT="Insert_your_github_token_here"

while true; do
  case "$1" in
     -b|--build)
      docker build -t $IMAGE_NAME:$VERSION \
                  -f "$ROOT_DIR/inst/Dockerfile" \
                  --build-arg PKG_VERSION=$VERSION \
                  "$ROOT_DIR" || exit 1
      shift;;
     -r|--run)
      docker stop $CONTAINER_NAME &> /dev/null
      docker rm $CONTAINER_NAME &> /dev/null
      docker run -dti --name $CONTAINER_NAME \
            -p $PORT:8000 \
            $IMAGE_NAME:$VERSION
      shift;;
     -p|--publish)
      echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
      docker tag $IMAGE_NAME:$VERSION ghcr.io/$GITHUB_REPOSITORY:$VERSION
	    docker push ghcr.io/$GITHUB_REPOSITORY:$VERSION
      shift;;
    *)
      echo "End of Script"
      break;;
  esac
done
