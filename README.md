
# Docker Build
sudo apt install docker docker-composev2 docker-buildx

## Enable nvidia runtime

TODO: Add link to NVidia instructions

# Run docker

`sudo docker run -it --rm --privileged -eDISPLAY --runtime=nvidia --gpus all -v/dev:/dev -v /tmp/.X11-unix:/tmp/.X11-unix sarndbox:test /opt/vrui/bin/SARndbox`

## Other options
sudo  SARndbox -uhm -rs 2 -ncl -uhs -ws 5 10 -wo 1 -us -nas 10 -loadInputGraph Adventure.inputgraph

# Install Antimicro for button control
