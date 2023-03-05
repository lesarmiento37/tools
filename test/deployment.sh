#!bin/bash
export CONTAINER=$(docker ps | awk '{print $1}' | tail -n 1)
echo $CONTAINER
docker rm --force $CONTAINER
docker rmi leonardo
docker build -t leonardo ./
docker run -d --name leonardo-requests -p 80:80 leonardo
sleep 2
python3.8 test.py
export CONTAINER_LOGS=$(docker ps | awk '{print $1}' | tail -n 1)
echo $CONTAINER_LOGS
docker logs $CONTAINER_LOGS
python3.8 test.py