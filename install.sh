#!/bin/bash

apt update && \
    apt install -y \
    gcc \
    make \
    g++ \
    zlib1g-dev \
    libopengl-dev \
    libssl-dev \
    libgl-dev \
    libtiff-dev \
    libopenal-dev \
    libasound2-dev \
    libfreetype-dev \
    fonts-freefont-ttf \
    libusb-1.0-0-dev \
    curl \
    patch \
    mesa-utils

VRUI=Vrui-8.0-002.tar.gz
KINECT=Kinect-3.10.tar.gz
SARND=SARndbox-2.8.tar.gz

curl -O https://web.cs.ucdavis.edu/~okreylos/ResDev/Vrui/$VRUI
curl -O https://web.cs.ucdavis.edu/~okreylos/ResDev/SARndbox/$SARND
curl -O https://web.cs.ucdavis.edu/~okreylos/ResDev/Kinect/$KINECT

VRUI_SHA1=a0448c79f2139a9d7223787858f935c3d7c6cd36
KINECT_SHA1=c676773a623596869ae2d9e01e3e941ef74efd9f
SARND_SHA1=01e0803f7cb61ec9e1b193d03558daa5e1234eb2

echo -en "$VRUI_SHA1 $VRUI\n$KINECT_SHA1 $KINECT\n$SARND_SHA1 $SARND" | sha1sum -c

tar xzf $VRUI
tar xzf $KINECT
tar xzf $SARND

$(cd $(basename -s.tar.gz $VRUI)  && patch -p2 < ../Vrui-0001.patch)

export INSTALLDIR=/opt/vrui
export VRUI_MAKEDIR=/opt/vrui/share/Vrui-8.0/make

# VRUI, KINECT, and SARndbox makefile install dependencies don't
# appear to work in parallel builds with all
make -j4 -C $(basename -s .tar.gz $VRUI) all
make -j4 -C $(basename -s .tar.gz $VRUI)  install
make -j4 -C $(basename -s .tar.gz $KINECT) KINECT_PROJECTORTYPE=1 all
make -j4 -C $(basename -s .tar.gz $KINECT) KINECT_PROJECTORTYPE=1 install
make -j4 -C $(basename -s .tar.gz $SARND) all
make -j4 -C $(basename -s .tar.gz $SARND) install
