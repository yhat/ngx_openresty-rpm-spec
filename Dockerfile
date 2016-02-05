FROM centos:7

USER root

COPY SOURCES /root/
COPY SPECS /root/
COPY Makefile /root/
COPY BUILD-and-INSTALL.sh /root/

WORKDIR /root/

RUN make
