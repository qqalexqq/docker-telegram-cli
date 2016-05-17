FROM pataquets/ubuntu:trusty

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      luajit \
      luarocks \
      libreadline-dev \
      libconfig-dev \
      libssl-dev \
      lua5.1 \
      liblua5.1-dev \
      libevent-dev \
      libjansson-dev \
      libpython3-dev \
      make \
      git \
      python3 \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

RUN \
  git clone --recursive https://github.com/vysheng/tg.git /tg && \
  cd /tg && \
  ./configure --enable-python && \
  make && \
  mv -v /tg/bin/* /usr/bin/ && \
  mkdir -vp /etc/telegram-cli/ && \
  rm -rf /tg/

ADD ./server.pub /etc/telegram-cli/server.pub

ENTRYPOINT /usr/bin/telegram-cli
