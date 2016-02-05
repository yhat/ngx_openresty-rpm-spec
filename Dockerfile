FROM centos:7

RUN yum groupinstall -y "Development Tools"

WORKDIR /root/

COPY SOURCES /root/SOURCES/
COPY SPECS /root/SPECS/
COPY Makefile /root/
COPY BUILD-and-INSTALL.sh /root/

RUN make
