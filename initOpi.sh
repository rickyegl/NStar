docker load -i northstar.tar
docker run -it --name northstar --restart=unless-stopped --device=/dev/video0:/dev/video0 rickyegl/northstar
