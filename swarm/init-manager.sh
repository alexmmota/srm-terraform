#!/bin/bash
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge"
apt-cache policy docker-ce
apt install -y docker-ce
mkdir /opt/srm
mv /tmp/swarm /opt/srm

# create cluster swarm
docker swarm init --advertise-addr $1
worker_token=$(docker swarm join-token -q worker)
ssh -o "StrictHostKeyChecking no" $2 docker swarm join --advertise-addr $2 --token ${worker_token} $1:2377
ssh -o "StrictHostKeyChecking no" $3 docker swarm join --advertise-addr $3 --token ${worker_token} $1:2377
