#!/usr/bin/env bash
if [ $# -lt 2 ]
  then
    echo "Not enough arguments supplied"
    echo "Usage: minify_docker_image IMAGE_ID TAG"
    exit 1
  else
    ID=$(sudo docker run -d $1 /bin/bash)
    (sudo docker export $ID | gzip -c > $ID.tgz)
    sudo docker stop $ID
    sudo docker rm $ID
    gzip -dc $ID.tgz | sudo docker import - $2
    sudo docker rmi $1
    rm -f $ID.tgz
fi
