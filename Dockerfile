# Usage:
#   docker run -ti --publish 53:53/tcp --publish 53:53/udp --name oob oob-christian

FROM ubuntu:latest
MAINTAINER Christian Lopez <christian@insertco.in>
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y git vim curl tmux dnsutils

WORKDIR /root
RUN git clone git://github.com/phr0nak/OOB-Server.git
WORKDIR /root/OOB-Server
RUN git checkout christian-stuff

RUN sed '10s/$/\tallow-recursion \{ 127\/8; \};\n/' /root/OOB-Server/_config/named.conf.options >> /tmp/named.conf.options
RUN cp /tmp/named.conf.options /root/OOB-Server/_config/named.conf.options

# RUN ./setup $DOMAIN $PUBLIC_IP ; exit 0
RUN ./setup "example.com" 127.0.0.1 ; exit 0 #changeme

CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "bind"]

