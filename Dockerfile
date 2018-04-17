FROM ubuntu:latest

MAINTAINER adam.copley

ENV DEBIAN_FRONTEND noninteractive

ARG DOMAIN
ARG JICOFO_AUTH_PASSWORD
ARG JICOFO_SECRET
ARG JVB_SECRET

# Install wget to be able to pull gpg key
RUN apt-get update -y
RUN apt-get install -y \
    wget \
    apt-transport-https

# Add the jitsi-meet stable repository
RUN wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -
RUN echo 'deb https://download.jitsi.org unstable/' > /etc/apt/sources.list.d/jitsi-unstable.list

# Install debconf-utils
RUN apt-get update && apt-get install -y \
  debconf-utils

# Prep debconf to auto include our build args
RUN echo "jitsi-meet-prosody	jicofo/jicofo-authpassword	password	${JICOFO_AUTH_PASSWORD}" | debconf-set-selections && \
  echo "jitsi-meet-prosody	jicofo/jicofosecret	password	${JICOFO_SECRET}" | debconf-set-selections && \
  echo "jitsi-meet-prosody	jitsi-videobridge/jvbsecret	password	${JVB_SECRET}" | debconf-set-selections && \
  echo "jitsi-videobridge	jitsi-videobridge/jvbsecret	password	${JVB_SECRET}" | debconf-set-selections && \
  echo "jicofo	jitsi-videobridge/jvb-hostname	string	${DOMAIN}" | debconf-set-selections && \
  echo "jitsi-meet-prosody	jitsi-videobridge/jvb-hostname	string	${DOMAIN}" | debconf-set-selections && \
  echo "jitsi-meet-web-config	jitsi-videobridge/jvb-hostname	string	${DOMAIN}" | debconf-set-selections && \
  echo "jitsi-videobridge	jitsi-videobridge/jvb-hostname	string	${DOMAIN}" | debconf-set-selections && \
  echo "jitsi-meet-web-config	jitsi-meet/cert-path-crt	string" | debconf-set-selections && \
  echo "jitsi-meet-prosody	jicofo/jicofo-authuser	string	focus" | debconf-set-selections && \
  echo "jitsi-meet-web-config	jitsi-meet/cert-path-key	string" | debconf-set-selections && \
  echo "jitsi-meet-web-config	jitsi-meet/jvb-hostname	string	${DOMAIN}" | debconf-set-selections && \
  echo "jitsi-meet-prosody	jitsi-meet-prosody/jvb-hostname	string	${DOMAIN}" | debconf-set-selections && \
  echo "jitsi-meet-web-config	jitsi-meet/jvb-serve	boolean	true" | debconf-set-selections

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
