FROM ubuntu:14.04
LABEL Maintainter="WarrensBox"

RUN apt-get update \
&&  apt-get upgrade -y --force-yes \
&&  apt-get install -y --force-yes \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    wget \
    curl \
    git \
    build-essential \
    xvfb \
    python3 \
    zip \
    unzip \
&&  apt-get clean \
&&  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

ENV GOVERSION 1.10.3
ENV GOROOT /opt/go
ENV GOPATH /home/warrensbox

RUN wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz 
RUN tar zxf go${GOVERSION}.linux-amd64.tar.gz -C /opt && rm go${GOVERSION}.linux-amd64.tar.gz 
RUN ln -s /opt/go/bin/go /usr/local/bin

RUN adduser --disabled-password --gecos '' warrensbox  

RUN usermod -aG sudo warrensbox
RUN chown warrensbox:warrensbox /usr/local/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0
USER warrensbox
WORKDIR /home/warrensbox
