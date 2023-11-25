#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo docker pull uachado/inventory-api:latest
sudo docker run -d -p 8000:8000 -e DATABASE_URL=${conn_str} uachado/inventory-api:latest
