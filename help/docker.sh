//delete all images and volumes
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker system prune -a -f --volumes

//install and run nstar
pscp "%USERPROFILE%\Downloads\docker-image.zip" orangepi@10.66.47.222:/home/orangepi
unzip -o docker-image.zip

docker load -i northstar.tar
docker run -it --name northstar -p 8000:8000 --restart=unless-stopped --device=/dev/video0:/dev/video0 rickyegl/northstar

//access filesystem
docker exec -it northstar /bin/bash

//override entrypoint
docker run -it --entrypoint /bin/bash --name northstar -p 8000:8000 --restart=unless-stopped --device=/dev/video0:/dev/video0 rickyegl/northstar

//install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py