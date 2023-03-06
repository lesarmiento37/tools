#!bin/bash
export CONTAINER=$(docker ps | awk '{print $1}' | tail -n 1)
echo $CONTAINER
docker rm --force $CONTAINER
docker rmi requester
docker build -t requester ./
docker run -d --name requests -p 80:80 requester
sleep 2
python3.8 test.py
export CONTAINER_LOGS=$(docker ps | awk '{print $1}' | tail -n 1)
echo $CONTAINER_LOGS
docker logs $CONTAINER_LOGS
python3.8 test.py

#####################primeros deployment########################
docker tag requester:v1 leonardos37/requester:v1
