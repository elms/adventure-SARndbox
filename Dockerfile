FROM ubuntu

ARG WS=/opt/SARndbox
ENV WS $WS

RUN mkdir -p $WS
WORKDIR $WS

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
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

ENV VRUI Vrui-8.0-002.tar.gz
ENV KINECT Kinect-3.10.tar.gz
ENV SARND SARndbox-2.8.tar.gz

RUN curl -O https://web.cs.ucdavis.edu/~okreylos/ResDev/Vrui/$VRUI && \
    curl -O https://web.cs.ucdavis.edu/~okreylos/ResDev/SARndbox/$SARND && \
    curl -O https://web.cs.ucdavis.edu/~okreylos/ResDev/Kinect/$KINECT

ENV VRUI_SHA1 a0448c79f2139a9d7223787858f935c3d7c6cd36
ENV KINECT_SHA1 c676773a623596869ae2d9e01e3e941ef74efd9f
ENV SARND_SHA1 01e0803f7cb61ec9e1b193d03558daa5e1234eb2

RUN echo -n "$VRUI_SHA1 $VRUI\n$KINECT_SHA1 $KINECT\n$SARND_SHA1 $SARND" | sha1sum -c

RUN tar xzf $VRUI
RUN tar xzf $KINECT
RUN tar xzf $SARND

COPY Vrui-0001.patch .
RUN cd $(basename -s.tar.gz $VRUI)  && patch -p2 < ../Vrui-0001.patch

ENV INSTALLDIR /opt/vrui

RUN make -j4 -C $(basename -s .tar.gz $VRUI) INSTALLDIR=$INSTALLDIR all
RUN make -j4 -C $(basename -s .tar.gz $VRUI) INSTALLDIR=$INSTALLDIR install

RUN make -j4 -C $(basename -s .tar.gz $KINECT) KINECT_PROJECTORTYPE=1 VRUI_MAKEDIR=$INSTALLDIR/share/Vrui-8.0/make all
RUN make -j4 -C $(basename -s .tar.gz $KINECT) KINECT_PROJECTORTYPE=1 VRUI_MAKEDIR=$INSTALLDIR/share/Vrui-8.0/make install

RUN make -j4 -C $(basename -s .tar.gz $SARND) VRUI_MAKEDIR=$INSTALLDIR/share/Vrui-8.0/make all
RUN make -j4 -C $(basename -s .tar.gz $SARND) VRUI_MAKEDIR=$INSTALLDIR/share/Vrui-8.0/make INSTALLDIR=$INSTALLDIR install

