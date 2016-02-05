FROM centos:7

RUN yum groupinstall -y "Development Tools"
RUN yum install -y sudo

RUN groupadd -r minion
RUN useradd -r -g minion -m -d /home/minion -s /bin/bash -c "minion" minion

COPY SOURCES /home/minion/SOURCES/
COPY SPECS /home/minion/SPECS/
COPY Makefile /home/minion/
COPY BUILD-and-INSTALL.sh /home/minion/

USER minion

WORKDIR /home/minion

RUN make
