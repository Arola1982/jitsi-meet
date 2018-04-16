FROM ubuntu:latest

MAINTAINER adam.copley

ENV DEBIAN_FRONTEND noninteractive

# Install wget to be able to pull gpg key
RUN apt-get update -y
RUN apt-get install -y \
    wget \
    apt-transport-https

# Add the jitsi-meet stable repository
RUN wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -
RUN echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list

# Install packages
RUN apt-get update -y
RUN apt-get install -y \
    jitsi-meet

COPY startup /startup
RUN chmod +x /startup

EXPOSE 443
EXPOSE 5222
EXPOSE 5269
EXPOSE 5280
EXPOSE 5347
EXPOSE 10000/udp
EXPOSE 10001/udp
EXPOSE 10002/udp
EXPOSE 10003/udp
EXPOSE 10004/udp
EXPOSE 10005/udp
EXPOSE 10006/udp
EXPOSE 10007/udp
EXPOSE 10008/udp
EXPOSE 10009/udp
EXPOSE 10010/udp

CMD /startup
