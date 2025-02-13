#!/bin/bash
echo 'xxxxxxxxxxx' > /home/ubuntu/dk-pwd.txt
cat /home/ubuntu/dk-pwd.txt | docker login --username usr --password-stdin

docker build --no-cache -t dockerhub/img-name:tag . && \
docker push dockerhub/img-name:tag
