FROM debian:jessie

RUN apt-get update && \
    apt-get upgrade -y

# Locales setup
## Install locales
RUN apt-get install -y locales

## Configure new locales
RUN localedef en_US.UTF-8 -i en_US -f UTF-8 && \
    localedef ru_RU.UTF-8 -i ru_RU -f UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

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

# Add user for telegram -d mode
RUN useradd -ms /bin/false telegramd

ENTRYPOINT /usr/bin/telegram-cli -k /etc/telegram-cli/server.pub
