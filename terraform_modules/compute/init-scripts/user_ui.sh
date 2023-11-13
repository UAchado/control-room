#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo docker pull uachado/user-ui:latest
sudo docker run -d -p 80:3000 uachado/user-ui:latest
