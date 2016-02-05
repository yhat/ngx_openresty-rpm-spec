FROM centos:7

RUN yum groupinstall -y "Development Tools"
RUN mkdir -p /home/root/

WORKDIR /home/root/

COPY SOURCES /home/root/SOURCES/
COPY SPECS /home/root/SPECS/
COPY Makefile /home/root/
COPY BUILD-and-INSTALL.sh /home/root/

RUN make
