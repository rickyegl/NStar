docker load -i northstar.tar
docker run -it --name northstar --device=/dev/video0:/dev/video0 rickyegl/northstar
