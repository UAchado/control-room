#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo docker pull uachado/user_ui:latest
sudo docker run -d -p 8000:8000 uachado/user_ui:latest
