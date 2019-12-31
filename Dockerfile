FROM ubuntu:14.04
LABEL Maintainter="https://github.com/warrensbox/go-rb-py-aws/issues/new"

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

RUN git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv \
&&  git clone git://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build \
&&  git clone git://github.com/jf/rbenv-gemset.git /usr/local/rbenv/plugins/rbenv-gemset \
&&  /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh \
&&  echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /root/.bashrc \
&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc

ENV CONFIGURE_OPTS --disable-install-doc
ENV PATH /usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH

ENV RBENV_VERSION 2.5.1

RUN eval "$(rbenv init -)"; rbenv install $RBENV_VERSION \
&&  eval "$(rbenv init -)"; rbenv global $RBENV_VERSION \
&&  eval "$(rbenv init -)"; gem update --system \
&&  eval "$(rbenv init -)"; gem install bundler -f \
&&  eval "$(rbenv init -)"; gem install jekyll -f \
&&  rm -rf /tmp/*

ENV GOVERSION 1.11.2
ENV GOROOT /opt/go
ENV GOPATH /home/warrensbox

RUN wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz 
RUN tar zxf go${GOVERSION}.linux-amd64.tar.gz -C /opt && rm go${GOVERSION}.linux-amd64.tar.gz 
RUN ln -s /opt/go/bin/go /usr/local/bin



RUN ln -s /usr/bin/python3 /usr/local/bin/python

RUN adduser --disabled-password --gecos '' warrensbox  

RUN usermod -aG sudo warrensbox
RUN chown warrensbox:warrensbox /usr/local/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0
USER warrensbox
WORKDIR /home/warrensbox

ENV PATH="/home/warrensbox/.local/bin:${PATH}"
RUN wget https://bootstrap.pypa.io/get-pip.py 
RUN python get-pip.py --user
RUN pip install awscli --upgrade --user

