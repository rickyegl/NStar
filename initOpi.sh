docker load -i northstar.tar
docker run -it --name northstar -p 8000:8000 --restart=unless-stopped --device=/dev/video0:/dev/video0 rickyegl/northstar
