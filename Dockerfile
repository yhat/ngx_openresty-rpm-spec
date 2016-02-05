FROM centos:7

USER root

RUN yum groupinstall -y "Development Tools"

COPY SOURCES /root/
COPY SPECS /root/
COPY Makefile /root/
COPY BUILD-and-INSTALL.sh /root/

WORKDIR /root/

RUN make
